module detection.packages;

@safe:

import std.process;
import std.string;

@trusted // For executeShell
string detectPackages()
{
    string rpm, flatpak;

    try {
        auto rpmResult = executeShell("rpm -qa | wc -l");
        if (rpmResult.status == 0)
            rpm = rpmResult.output.strip();
    } catch(Exception) {}

    try {
        auto flatpakResult = executeShell("flatpak list | wc -l");
        if (flatpakResult.status == 0)
            flatpak = flatpakResult.output.strip();
    } catch(Exception) {}

    string result;
    if (rpm.length > 0)
        result ~= rpm ~ " (rpm)";
    if (flatpak.length > 0)
    {
        if (result.length > 0)
            result ~= ", ";
        result ~= flatpak ~ " (flatpak)";
    }

    return result;
}