@safe:
import std.stdio;
import std.string;
import std.exception;
import std.getopt;
import core.time;
import std.datetime.stopwatch;

import detection.host;
import detection.os; // detectOS, detectOSID
import detection.kernel;
import detection.uptime;
import detection.board;
import detection.bios;
import detection.chassis;
import detection.publicip;
import detection.appversion;
import detection.packages;
import detection.shell;
import detection.display;
import detection.de;
import detection.wm;
import detection.theme;
import detection.icons;
import detection.font;
import detection.cursor;
import detection.terminal;
import detection.cpu;
import detection.gpu;
import detection.memory;
import detection.swap;
import detection.disk;
import detection.localip;
import detection.locale;

import common.color;
import logos;

struct Info { string key; string function() @safe value; Color keyColor = Color.blue; }
struct TimingInfo { string name; Duration time; }

string formatBoard() @safe
{
    auto board = detectBoard();
    string res;
    if(board.vendor.length > 0)
        res ~= board.vendor ~ " ";
    res ~= board.name;
    if(board.boardVersion.length > 0)
        res ~= " " ~ board.boardVersion;
    if(board.serial.length > 0)
        res ~= " (" ~ board.serial ~ ")";
    enforce(res.length > 0, "No board info found");
    return res;
}

string formatBios() @safe
{
    auto bios = detectBios();
    string res;
    if(bios.vendor.length > 0)
        res ~= bios.vendor ~ " ";
    if(bios.biosVersion.length > 0)
        res ~= bios.biosVersion;
    if(bios.release.length > 0 || bios.date.length > 0)
    {
        res ~= " (";
        if(bios.release.length > 0)
            res ~= "release " ~ bios.release;
        if(bios.release.length > 0 && bios.date.length > 0)
            res ~= ", ";
        if(bios.date.length > 0)
            res ~= bios.date;
        res ~= ")";
    }
    if(bios.type.length > 0)
        res ~= " [" ~ bios.type ~ "]";

    enforce(res.length > 0, "No bios info found");
    return res;
}

string formatChassis() @safe
{
    auto chassis = detectChassis();
    string res;
    if(chassis.vendor.length > 0 && chassis.vendor != "Default string")
        res ~= chassis.vendor ~ " ";
    res ~= chassis.type;
    if(chassis.chassisVersion.length > 0 && chassis.chassisVersion != "Default string")
        res ~= " " ~ chassis.chassisVersion;
    if(chassis.serial.length > 0 && chassis.serial != "Default string")
        res ~= " (" ~ chassis.serial ~ ")";
    enforce(res.length > 0, "No chassis info found");
    return res;
}

string formatPublicIp() @trusted
{
    auto ip = detectPublicIp();
    if(ip.location.length > 0)
        return ip.ip ~ " [" ~ ip.location ~ "]";
    return ip.ip;
}

string formatVersion() @safe
{
    auto v = detectVersion();
    return v.projectName ~ " " ~ v.appVersion;
}

void main(string[] args)
{
    bool verbose = false;
    bool noPackages = false; // Option to skip slow package counting
    auto helpInformation = getopt(args,
        "verbose", &verbose,
        "no-packages", &noPackages,
    );
    if (helpInformation.helpWanted)
    {
        defaultGetoptPrinter("Usage: fastfetch-d [--verbose]", helpInformation.options);
        return;
    }

    Info[] infos;
    infos ~= Info("OS", &detectOS, Color.green);
    infos ~= Info("Kernel", &detectKernel, Color.green);
    infos ~= Info("Uptime", &detectUptime, Color.green);
    infos ~= Info("Board", &formatBoard, Color.green);
    infos ~= Info("Bios", &formatBios, Color.green);
    infos ~= Info("Chassis", &formatChassis, Color.green);
    if(!noPackages) infos ~= Info("Packages", &detectPackages, Color.green);
    infos ~= Info("Shell", &detectShell, Color.green);
    infos ~= Info("Display (VG245)", &detectDisplay, Color.green);
    infos ~= Info("DE", &detectDE, Color.green);
    infos ~= Info("WM", &detectWM, Color.green);
    infos ~= Info("WM Theme", &detectTheme, Color.green);
    infos ~= Info("Theme", &detectTheme, Color.green);
    infos ~= Info("Icons", &detectIcons, Color.green);
    infos ~= Info("Font", &detectFont, Color.green);
    infos ~= Info("Cursor", &detectCursor, Color.green);
    infos ~= Info("Terminal", &detectTerminal, Color.green);
    infos ~= Info("CPU", &detectCPU, Color.red);
    infos ~= Info("GPU", &detectGPU, Color.red);
    infos ~= Info("Memory", &detectMemory, Color.red);
    infos ~= Info("Swap", &detectSwap, Color.red);
    infos ~= Info("Disk (/)", &detectDisk, Color.red);
    infos ~= Info("Local IP (enp5s0)", &detectLocalIP, Color.yellow);
    infos ~= Info("Public IP", &formatPublicIp, Color.yellow);
    infos ~= Info("Locale", &detectLocale, Color.yellow);
    infos ~= Info("Version", &formatVersion, Color.yellow);

    TimingInfo[] timings;

    string distroID;
    try distroID = detectOSID(); catch(Exception) distroID = "unknown";
    auto logo = getLogoForDistro(distroID);
    auto logoLines = logo.split('\n');

    string host;
    try
    {
        StopWatch sw;
        if (verbose) sw.start();
        host = colorize(detectHost(), Color.cyan);
        if (verbose)
        {
            sw.stop();
            timings ~= TimingInfo("Host", sw.peek());
        }
    }
    catch(Exception e)
    {
        host = e.msg;
    }

    // Print first lines with host appended similar to original logic
    size_t lineCount = logoLines.length;
    if (lineCount == 0) return;

    // We'll align info output starting after logo height; treat remaining lines as padding.
    writeln(logoLines[0]);
    if (lineCount > 1) writeln(logoLines[1]);
    if (lineCount > 2) writeln(logoLines[2]);
    if (lineCount > 3) writeln(logoLines[3]);
    if (lineCount > 4) { write(logoLines[4]); writeln("      ", host); } else { writeln(host); }
    if (lineCount > 5) { write(logoLines[5]); writeln("     ", colorize("---------------", Color.brightBlack)); }

    for(int i = 0; i < infos.length; ++i)
    {
        if(i + 6 < logoLines.length) write(logoLines[i+6]); else write("                                          ");
        try {
            StopWatch sw;
            if (verbose) sw.start();
            string result = infos[i].value();
            if (verbose)
            {
                sw.stop();
                timings ~= TimingInfo(infos[i].key, sw.peek());
            }
            write("    ", colorize(infos[i].key, infos[i].keyColor), ": ", result);
        } catch(Exception e) {
            write("    ", colorize(infos[i].key, infos[i].keyColor), ": ", e.msg);
        }
        writeln();
    }

    for(size_t i = infos.length + 6; i < logoLines.length; ++i) writeln(logoLines[i]);

    if (verbose)
    {
        writeln("\n--- Timing Report ---");
        Duration total; foreach(t; timings) { writeln(t.name, ": ", t.time); total += t.time; }
        writeln("---------------------"); writeln("Total: ", total);
    }
}
