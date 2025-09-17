module detection.cpu;

@safe:

import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.string;

string detectCPU()
{
    try
    {
        string cpuinfo = readText("/proc/cpuinfo");
        foreach (line; cpuinfo.splitLines())
        {
            if (line.startsWith("model name"))
            {
                auto parts = line.split(":");
                if (parts.length > 1)
                {
                    return parts[1].strip();
                }
            }
        }
    }
    catch (Exception) {}

    return "Unknown CPU";
}
