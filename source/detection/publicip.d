module detection.publicip;

import std.exception : enforce;
import std.process : pipeProcess, wait, ProcessPipes;
import std.algorithm.iteration : joiner; // still used in other modules; not strictly needed after refactor but kept for potential future chunk ops
import std.array : array; // for potential future use
import std.conv : to;
import std.json : parseJSON, JSONValue;
import std.string : strip;

struct PublicIpResult
{
    string ip;
    string location;
}

// This function is marked as trusted because it performs network IO, which is an
// external system interaction not verifiable by the @safe checker. The function
// itself is safe in terms of memory management and type safety.
@trusted PublicIpResult detectPublicIp(string url = "http://ipinfo.io/json", uint timeout = 2000)
{
    auto pipes = pipeProcess(["curl", "-s", "--max-time", to!string(timeout / 1000.0), url]);
    wait(pipes.pid);

    // Collect raw bytes from stdout. We avoid to!string on a ubyte[] because that
    // formats the array as "[123, 10, ...]" instead of interpreting it as UTF-8 text.
    ubyte[] buffer;
    foreach (chunk; pipes.stdout.byChunk(4096))
        buffer ~= chunk; // append chunk bytes

    // ipinfo.io returns UTF-8 JSON. Casting is safe here (data is transient, no mutation afterwards).
    // If validation is desired, we could call std.utf.validate(buffer) first.
    string response = cast(string) buffer;
    response = response.strip;

    try
    {
        auto json = parseJSON(response);

        PublicIpResult result;
        result.ip = json["ip"].str;

        string city = "city" in json ? json["city"].str : "";
        string country = "country" in json ? json["country"].str : "";

        if (city.length > 0 && country.length > 0)
            result.location = city ~ ", " ~ country;
        else if (city.length > 0)
            result.location = city;
        else
            result.location = country;

        enforce(result.ip.length > 0, "Failed to detect public IP");
        return result;
    }
    catch(Exception e)
    {
        enforce(false, response);
    }
    assert(0);
}

unittest
{
    // Ensure that casting a ubyte[] holding JSON to string works with the parser path.
    auto sample = `{"ip":"1.2.3.4","city":"SampleCity","country":"SC"}`;
    auto bytes = cast(ubyte[]) sample.dup; // simulate process output
    auto text = cast(string) bytes;
    auto json = parseJSON(text);
    assert(json["ip"].str == "1.2.3.4");
    assert(json["city"].str == "SampleCity");
}
