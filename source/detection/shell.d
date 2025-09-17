module detection.shell;

@safe:

import std.process;
import std.string;
import std.path;

@trusted // For executeShell
string detectShell()
{
    try
    {
        auto result = executeShell("ps -p $$ -o comm=");
        if(result.status == 0)
        {
            string shellName = result.output.strip();
            auto versionResult = executeShell(shellName ~ " --version");
            if(versionResult.status == 0)
            {
                string firstLine = versionResult.output.splitLines[0];
                return firstLine.split(" ")[2] ~ " " ~ firstLine.split(" ")[3];
            }
            return shellName;
        }
    }
    catch(Exception) {}

    return "Unknown";
}