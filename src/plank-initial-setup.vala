/**
* SPDX-License-Identifier: BSD-2-Clause
* Copyright (c) 2020, Olivier Duchateau <duchateau.olivier@gmail.com>
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer
*    in the documentation and/or other materials provided with the
*    distribution.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
* COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
* ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

static bool
file_exists (string filename) {
    bool result = false;
    GLib.File file;

    file = GLib.File.new_for_path (filename);
    if (file.query_exists ()) {
        result = true;
    }

    return result;
}

static void
write_content (string filename) {
    try {
        GLib.FileUtils.set_contents (filename, "yes", -1);
    } catch (GLib.FileError err) {
        stderr.printf ("%s\n", err.message);
    }
}

static string
set_path (string parent, string basename) {
    string fullname;

    fullname = GLib.Path.build_path (GLib.Path.DIR_SEPARATOR_S,
                                     parent, basename);

    return fullname;
}

static void
create_subdirectories (string path) {
    GLib.File file;

    file = GLib.File.new_for_path (path);
    if (!file.query_exists ()) {
        try {
            file.make_directory_with_parents ();
        } catch (GLib.Error err) {
            stderr.printf ("%s\n", err.message);
        }
    }
}

static GLib.List<GLib.File>?
list_directory (string path) {
    GLib.File file;
    GLib.FileEnumerator file_enum;
    GLib.FileInfo file_info;
    GLib.FileType file_type;
    GLib.List<GLib.File> list_files;

    list_files = new GLib.List<GLib.File> ();

    file = GLib.File.new_for_path (path);
    try {
        file_enum = file.enumerate_children (GLib.FileAttribute.STANDARD_NAME,
                                             GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
        while ((file_info = file_enum.next_file (null)) != null) {
            file_type = file_info.get_file_type ();
            if (file_type == GLib.FileType.REGULAR) {
                string fullname;

                fullname = set_path (file.get_path (),
                                     file_info.get_name ());
                list_files.append (GLib.File.new_for_path (fullname));
            }
        }
    } catch (GLib.Error err) {
        stderr.printf ("%s\n", err.message);
    }

    return list_files;
}

static void
set_plank_user_config_dir (string parent) {
    string launcher_dir;
    GLib.File dst;
    GLib.List<GLib.File>? launchers;

    launcher_dir = set_path (parent, "plank/dock1/launchers");
    create_subdirectories (launcher_dir);

    // Get list of available launchers
    launchers = list_directory (set_path (Config.INSTALL_PREFIX,
                                          "share/plank/launchers"));
    foreach (GLib.File launcher in launchers) {
        try {
            string name;

            // Basename
            name = launcher.get_basename ();

            dst = GLib.File.new_for_path (set_path (launcher_dir, name));
            launcher.copy (dst, GLib.FileCopyFlags.TARGET_DEFAULT_PERMS);
        } catch (GLib.Error err) {
            stderr.printf ("%s\n", err.message);
        }
    }
}

static void
set_plank_autostart (string parent) {
    string autostart_dir;
    GLib.File src;

    autostart_dir = set_path (parent, "autostart");
    create_subdirectories (autostart_dir);

    src = GLib.File.new_for_path (set_path (Config.INSTALL_PREFIX,
                                            "share/applications/plank.desktop"));
    try {
        src.copy (GLib.File.new_for_path (set_path (autostart_dir,
                                                    "plank.desktop")),
                  GLib.FileCopyFlags.TARGET_DEFAULT_PERMS);
    } catch (GLib.Error err) {
        stderr.printf ("%s\n", err.message);
    }
}

static void
plank_initial_setup () {
    unowned string config_dir;
    string file;

    config_dir = GLib.Environment.get_user_config_dir ();
    file = set_path (config_dir, "plank-initial-setup-done");

    if (file_exists (file))  {
        string content;

        try {
            GLib.FileUtils.get_contents (file, out content);
            // Remove and recreate
            if (content != "yes") {
                GLib.FileUtils.remove (file);
            }
            set_plank_user_config_dir (config_dir);
            set_plank_autostart (config_dir);

            write_content (file);
        } catch (GLib.FileError err) {
            stderr.printf ("%s\n", err.message);
        }
    }
    else {
        set_plank_user_config_dir (config_dir);
        set_plank_autostart (config_dir);

        write_content (file);
    }
}

static int
main (string[] args) {
    Act.UserManager manager;
    GLib.SList<unowned Act.User> users;
    // Name of the current user
    string current_user = GLib.Environment.get_user_name ();

    manager = Act.UserManager.get_default ();
    users = manager.list_users ();

    foreach (unowned Act.User user in users) {
        if (user.get_user_name () == current_user) {
            plank_initial_setup ();
            break;
        }
    }

    return 0;
}
