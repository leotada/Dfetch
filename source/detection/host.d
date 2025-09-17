module detection.host;

@safe:

import core.sys.posix.unistd : gethostname;
import std.file : readText;
import std.string : fromStringz, strip;
import std.exception : enforce;

@trusted // For gethostname
string detectHost()
{
    try
    {
        string hostname = readText("/etc/hostname").strip();
        if (hostname.length > 0)
        {
            return hostname;
        }
    }
    catch (Exception)
    {
        // fallthrough
    }

    char[256] buffer;
    enforce(gethostname(buffer.ptr, buffer.length) == 0, "gethostname() failed");
            return fromStringz(buffer.ptr).idup;
}
