module detection.swap;

@safe:

import std.file;
import std.string;
import std.conv;

private string formatSize(ulong size_mib)
{
    if(size_mib < 1024)
        return format("%d MiB", size_mib);
    else
        return format("%.2f GiB", size_mib / 1024.0);
}

string detectSwap()
{
    try
    {
        ulong total = 0;
        ulong free = 0;
        bool foundSwap = false;

        foreach (line; readText("/proc/meminfo").splitLines())
        {
            if (line.startsWith("SwapTotal:"))
            {
                total = line["SwapTotal:".length..$].strip().split(' ')[0].to!ulong / 1024;
                foundSwap = true;
            }
            else if (line.startsWith("SwapFree:"))
            {
                free = line["SwapFree:".length..$].strip().split(' ')[0].to!ulong / 1024;
            }
        }

        if (!foundSwap || total == 0)
        {
            return "0 B / 0 B (0%)";
        }

        ulong used = total - free;
        return format("%s / %s (%d%%)", formatSize(used), formatSize(total), total > 0 ? (used * 100 / total) : 0);
    }
    catch (Exception)
    {
        return "0 B / 0 B (0%)"; // If parsing fails, assume no swap
    }
}