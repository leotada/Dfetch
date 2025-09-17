module detection.appversion;

import std.exception : enforce;

struct VersionResult
{
    string projectName;
    string sysName;
    string architecture;
    string appVersion;
    string versionTweak;
    string versionGit;
    string dubBuildType;
    string compileTime;
    string compiler;
    bool debugMode;
}

import std.json : parseJSON;
import std.file : readText;

VersionResult detectVersion() @safe
{
    VersionResult result;

    auto dubJson = parseJSON(readText("dub.json"));
    result.projectName = dubJson["name"].str;
    result.appVersion = dubJson["version"].str;
    result.versionTweak = "";
    result.versionGit = ""; // Placeholder

    version(linux) result.sysName = "Linux";
    else version(Windows) result.sysName = "Windows";
    else version(OSX) result.sysName = "macOS";
    else version(FreeBSD) result.sysName = "FreeBSD";
    else version(DragonFlyBSD) result.sysName = "DragonFly";
    else version(NetBSD) result.sysName = "NetBSD";
    else version(OpenBSD) result.sysName = "OpenBSD";
    else version(Android) result.sysName = "Android";
    else result.sysName = "Unknown";

    version(X86_64) result.architecture = "x86_64";
    else version(X86) result.architecture = "i386";
    else version(AArch64) result.architecture = "aarch64";
    else version(ARM) result.architecture = "arm";
    else version(MIPS) result.architecture = "mips";
    else version(PPC) result.architecture = "powerpc";
    else version(RISCV) result.architecture = "riscv";
    else version(S390X) result.architecture = "s390x";
    else result.architecture = "Unknown";

    debug result.dubBuildType = "debug";
    else result.dubBuildType = "release";

    result.compileTime = __DATE__ ~ " " ~ __TIME__;

    version(LDC) result.compiler = "ldc " ~ __LDC_VERSION__;
    else version(DMD) result.compiler = "dmd " ~ __DMD_VERSION__;
    else version(GDC) result.compiler = "gdc " ~ __GDC_VERSION__;
    else result.compiler = "unknown";

    debug result.debugMode = true;
    else result.debugMode = false;

    return result;
}
