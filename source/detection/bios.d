module detection.bios;

import std.exception : enforce;
import std.file : exists;
import std.string : chomp;

struct BiosResult
{
    string date;
    string release;
    string vendor;
    string biosVersion;
    string type;
}

private string readDmi(string name) @trusted
{
    version(linux)
    {
        import std.file : read;
        foreach(p; ["/sys/devices/virtual/dmi/id/", "/sys/class/dmi/id/"])
        {
            auto path = p ~ name;
            if(exists(path))
            {
                try
                {
                    auto content = cast(string)read(path);
                    return content.chomp;
                }
                catch(Exception e) {}
            }
        }
    }
    return null;
}

BiosResult detectBios() @trusted
{
    BiosResult bios;

    version(linux)
    {
        bios.date = readDmi("bios_date");
        bios.release = readDmi("bios_release");
        bios.vendor = readDmi("bios_vendor");
        bios.biosVersion = readDmi("bios_version");

        if (exists("/sys/firmware/efi") || exists("/sys/firmware/acpi/tables/UEFI"))
            bios.type = "UEFI";
        else
            bios.type = "BIOS";

        if(bios.vendor.length > 0)
            return bios;
    }
    else version(Windows)
    {
        //TODO
    }
    else version(OSX)
    {
        //TODO
    }

    enforce(false, "Bios detection not implemented on this platform");
    return bios; //This is not reachable, but compiler complains
}
