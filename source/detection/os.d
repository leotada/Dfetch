module detection.os;

@safe:

import common.parsing;
import std.file : exists;
import std.exception : enforce;
import std.string : split, strip, toLower;

string detectOS()
{
    if (exists("/etc/os-release"))
    {
        return parsePropFile("/etc/os-release", "PRETTY_NAME");
    }

    if (exists("/usr/lib/os-release"))
    {
        return parsePropFile("/usr/lib/os-release", "PRETTY_NAME");
    }

    enforce(false, "Could not detect OS");
    assert(0);
}

// Returns canonical distribution id (like "arch", "ubuntu", "debian", "fedora", etc.).
// Fallback order: ID -> first from ID_LIKE list -> lowercased PRETTY_NAME token.
string detectOSID()
{
    string path;
    if (exists("/etc/os-release"))
        path = "/etc/os-release";
    else if (exists("/usr/lib/os-release"))
        path = "/usr/lib/os-release";
    else enforce(false, "Could not detect OS ID");

    string id;
    try { id = parsePropFile(path, "ID"); } catch(Exception) {}
    if (id.length) return id.toLower();

    string idLike;
    try { idLike = parsePropFile(path, "ID_LIKE"); } catch(Exception) {}
    if (idLike.length)
    {
        auto first = idLike.split();
        if (first.length) return first[0].toLower();
    }

    string pretty;
    try { pretty = parsePropFile(path, "PRETTY_NAME"); } catch(Exception) {}
    if (pretty.length)
    {
        auto tokens = pretty.split();
        if (tokens.length) return tokens[0].toLower();
    }

    return "unknown";
}
