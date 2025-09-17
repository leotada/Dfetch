module detection.de;

@safe:

import std.process;
import std.string;

@trusted // For executeShell
string detectDE()
{
    try
    {
        auto result = executeShell("echo $XDG_CURRENT_DESKTOP");
        if(result.status == 0 && result.output.length > 0)
        {
            return result.output.strip();
        }
    }
    catch(Exception){}
    return "KDE Plasma 6.4.4"; // Placeholder
}