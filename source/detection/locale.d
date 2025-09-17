module detection.locale;

@safe:

import std.process;
import std.string;

@trusted // For executeShell
string detectLocale()
{
    try
    {
        auto result = executeShell("echo $LANG");
        if(result.status == 0 && result.output.length > 0)
        {
            return result.output.strip();
        }
    }
    catch(Exception) {}
    return "Error";
}