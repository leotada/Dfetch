module detection.memory;

@safe:

import std.file;
import std.string;
import std.conv;
import std.format;

private string formatSize(ulong size_mib)
{
    if(size_mib < 1024)
        return format("%d MiB", size_mib);
    else
        return format("%.2f GiB", size_mib / 1024.0);
}

string detectMemory()
{
    try
    {
        ulong memTotal = 0;
        ulong memAvailable = 0; // Using MemAvailable for a more realistic "free" memory value

        foreach (line; readText("/proc/meminfo").splitLines())
        {
            if (line.startsWith("MemTotal:"))
            {
                memTotal = line["MemTotal:".length..$].strip().split(' ')[0].to!ulong / 1024;
            }
            else if (line.startsWith("MemAvailable:"))
            {
                memAvailable = line["MemAvailable:".length..$].strip().split(' ')[0].to!ulong / 1024;
            }
        }

        if (memTotal > 0)
        {
            ulong used = memTotal - memAvailable;
            return format("%s / %s (%d%%)", formatSize(used), formatSize(memTotal), (used * 100) / memTotal);
        }
    }
    catch (Exception) {}

    return "Error";
}