module detection.terminal;

@safe:

import std.process;
import std.string;

@trusted // For executeShell
string detectTerminal()
{
    try
    {
        auto result = executeShell("ps -p $(ps -p $$ -o ppid=) -o comm=");
        if(result.status == 0)
        {
            return result.output.strip();
        }
    }
    catch(Exception){}
    return "code 1.103.2"; // Placeholder
}