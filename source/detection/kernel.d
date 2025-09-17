module detection.kernel;

@safe:

import core.sys.posix.sys.utsname;
import std.string : fromStringz;
import std.exception : enforce;

@trusted // For uname
string detectKernel()
{
    utsname uts;
    enforce(uname(&uts) == 0, "uname() failed");

    return cast(string)fromStringz(uts.sysname.ptr) ~ " " ~ cast(string)fromStringz(uts.release.ptr);
}
