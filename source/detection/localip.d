module detection.localip;

@safe:

import std.process;
import std.string;
import std.array;

@trusted // For executeShell
string detectLocalIP()
{
    try
    {
        auto result = executeShell("ip route get 1.1.1.1");
        if (result.status == 0)
        {
            auto parts = result.output.split(' ');
            foreach_reverse(i, part; parts)
            {
                if(part == "src")
                    return parts[i + 1];
            }
        }
    }
    catch (Exception) {}
    return "Error";
}