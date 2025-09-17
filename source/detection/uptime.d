module detection.uptime;

@safe:

import std.file;
import std.string;
import std.conv;
import std.format;

string detectUptime()
{
    try
    {
        string content = readText("/proc/uptime");
        // The first value is the total uptime in seconds.
        // It can be a floating point number.
        real uptimeSeconds = content.split(' ')[0].to!real;
        long uptime = cast(long)uptimeSeconds;

        int days = cast(int)(uptime / (24 * 3600));
        uptime %= (24 * 3600);
        int hours = cast(int)(uptime / 3600);
        uptime %= 3600;
        int mins = cast(int)(uptime / 60);

        string result;
        if (days > 0) result ~= format("%d day(s), ", days);
        if (hours > 0 || days > 0) result ~= format("%d hour(s), ", hours);
        result ~= format("%d min(s)", mins);

        return result;
    }
    catch(Exception)
    {
        return "Error";
    }
}