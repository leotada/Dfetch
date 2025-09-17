module detection.gpu;

@safe:

import std.process;
import std.string;

@trusted // For executeShell
string detectGPU()
{
    try
    {
        auto result = executeShell("lspci | grep VGA");
        if(result.status == 0)
        {
            string firstLine = result.output.splitLines()[0];
            auto parts = firstLine.split(": ");
            if(parts.length > 1)
            {
                return parts[1].strip();
            }
        }
    }
    catch(Exception){}

    return "Unknown GPU";
}
