module detection.board;

import std.exception : enforce;
import std.file : exists, read, readText;
import std.string : strip, split, chomp;
import std.algorithm : find;

struct BoardResult
{
    string name;
    string vendor;
    string boardVersion;
    string serial;
}

private string readDmi(string name) @trusted
{
    //ffGetSmbiosValue
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

BoardResult detectBoard() @trusted
{
    BoardResult board;

    version(linux)
    {
        board.name = readDmi("board_name");
        if(board.name.length > 0)
        {
            board.vendor = readDmi("board_vendor");
            board.boardVersion = readDmi("board_version");
            board.serial = readDmi("board_serial");
            return board;
        }

        try
        {
            board.name = readText("/proc/device-tree/board").strip;
            if(board.name.length > 0) return board;
        }
        catch(Exception e) {}

        try
        {
            auto compatible = readText("/proc/device-tree/compatible");
            auto parts = compatible.split(',');
            if(parts.length > 1)
            {
                board.vendor = parts[0].strip;
                board.name = parts[1].strip;
                return board;
            }
        }
        catch(Exception e) {}
    }
    else version(Windows)
    {
        //TODO
    }
    else version(OSX)
    {
        //TODO
    }

    enforce(false, "Board detection not implemented on this platform");
    return board; //This is not reachable, but compiler complains
}
