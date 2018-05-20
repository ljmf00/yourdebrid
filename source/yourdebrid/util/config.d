/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.util.config;

import std.path, std.file, std.json;

/// Config manager class
class ConfigManager {
    private string path = "";
    private JSONValue config;
    private string[] paths;

    /// Finds the config file
    this()
    {
        version(Posix)
        {
            paths = [
                        getcwd() ~ "/yourdebrid.json",
                        "/etc/yourdebrid.json",
                        "/etc/yourdebrid/yourdebrid.json",
                        "/usr/share/yourdebrid/yourdebrid.json",
                        "/usr/local/share/yourdebrid/yourdebrid.json",
                        expandTilde("~/.config/yourdebrid/yourdebrid.json"),
                        expandTilde("~/.local/share/yourdebrid/yourdebrid.json"),
                        expandTilde("~/yourdebrid/yourdebrid.json")
                    ];
        } // TODO: Add windows support

        version(unittest)
        {
            paths ~= getcwd() ~ "/../assets/yourdebrid.json";
        }

        findFile: foreach(file; paths)
        {
            try
            {
                if(file.isFile())
                {
                    path = file;
                    break findFile;
                }
            } catch (Exception e) {}
        }

        if(path == "")
        {
            import std.c.stdlib : exit;
            import std.stdio : writeln;
            writeln("No config file found!");
            exit(0);
        }

        config = parseJSON(readText(path));
    }

    public JSONValue getData()
    {
        return config;
    }

}