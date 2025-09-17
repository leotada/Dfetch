module detection.disk;

@safe:

import std.process;
import std.string;
import std.array;
import std.algorithm;

@trusted // For executeShell
string detectDisk()
{
    try
    {
        auto result = executeShell("df -h /");
        if (result.status == 0)
        {
            auto lines = result.output.splitLines();
            if (lines.length > 1)
            {
                auto fields = lines[1].split(' ').filter!(a => a.length > 0).array;
                if (fields.length >= 5)
                {
                    return format("%s / %s (%s)", fields[2], fields[1], fields[4]);
                }
            }
        }
    }
    catch (Exception) {}
    return "Error";
}