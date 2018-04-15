
// CiaGenerate [Win32] prototype using Haxe, built to C++

class CiaGenerate
{
    static var Title = "CiaGenerate: Homebrew, DSiWare and retail CIA builder";
    static var Version = "0.3";
    static var BuildDate = "15th April 2018";

    public static function main()
    {
        switch(Sys.systemName())
        {
            case "Windows":
                Sys.command("title " + CiaGenerate.Title);
            
            /*
            case "Linux":
                Sys.command(" what does linux terminal use to set its title? ");
            */
        }
        var dir = new haxe.io.Path(Sys.programPath()).dir;
        Sys.setCwd(dir);
        Sys.println("");
        Sys.println(" --- " + CiaGenerate.Title + " --- ");
        Sys.println("");
        Sys.println(" - Copyright (C) 2018 by XorTroll");
        Sys.println(" - Version: v" + CiaGenerate.Version + ", built on " + CiaGenerate.BuildDate);
        Sys.println(" - Remade with Haxe language, compiled to C++ binary");
        Sys.println("");
        Sys.println(" - Warning: DSiWare CIA building method is experimental,");
        Sys.println("   so it might always not work.");
        if(Sys.args().length != 1) CiaGenerate.makeError("This program must be opened with a file to convert it.");
        var input = Sys.args()[0];
        var req = CiaGenerate.requiredFiles();
        for(r in req)
        {
            if(!sys.FileSystem.exists(r)) CiaGenerate.makeError("Required file was not found: " + r);
        }
        var ext = haxe.io.Path.extension(input).toLowerCase();
        if(!sys.FileSystem.exists(input)) CiaGenerate.makeError("Given file does not exist.");
        switch(ext)
        {
            case "nds" | "srl":
                CiaGenerate.buildDSiWare(input);
            case "3ds" | "cci":
                CiaGenerate.buildCCI(input);
            case "3dsx":
                CiaGenerate.build3DSX(input);
            default:
                CiaGenerate.makeError("Unknown file format. Must be NDS/SRL, 3DSX or 3DS/CCI.");
        }
        CiaGenerate.endProgram();
    }

    public static function buildCCI(Path)
    {
        Sys.println("");
        Sys.println(" - Building CIA from 3DS/CCI ROM: " + Path);
        var pth = new haxe.io.Path(Path);
        pth.ext = "cia";
        var outfle = pth.file + "." + pth.ext;
        var output = pth.toString();
        if(sys.FileSystem.exists(output)) sys.FileSystem.deleteFile(output);
        var command1 : String;
        var dir = new haxe.io.Path(Sys.programPath()).dir;
        switch(Sys.systemName())
        {
            case "Windows":
                command1 = "3dsconv.exe --boot9=\"" + dir + "\\boot9.bin\" \"" + Path + "\"";
            default:
                command1 = "";
        }
        var p1 = new sys.io.Process(command1);
        var ecode = p1.exitCode();
        if(sys.FileSystem.exists(dir + "\\" + outfle)) sys.FileSystem.deleteFile(dir + "\\" + outfle);
        sys.FileSystem.rename(dir + "\\" + outfle, output);
        if(!sys.FileSystem.exists(output)) CiaGenerate.makeError("Failure generating CIA archive: final build failed");
        else Sys.println(" - Successfully built CIA archive: " + output);
    }

    public static function build3DSX(Path)
    {
        Sys.println("");
        Sys.println(" - Building homebrew CIA from: " + Path);
        var pth = new haxe.io.Path(Path);
        pth.ext = "cxi";
        var cxifle = pth.toString();
        var cxi = pth.toString();
        pth.ext = "cia";
        var output = pth.toString();
        if(sys.FileSystem.exists(output)) sys.FileSystem.deleteFile(output);
        var command1 : String;
        var command2 : String;
        switch(Sys.systemName())
        {
            case "Windows":
                command1 = "cxitool.exe \"" + Path + "\" \"" + cxi + "\"";
                command2 = "makerom.exe -f cia -o \"" + StringTools.replace(output, "/", "\\") + "\" -target t -i \"" + StringTools.replace(cxi, "/", "\\") + "\":0:0";
            default:
                command1 = "";
                command2 = "";
        }
        var p1 = new sys.io.Process(command1);
        var ecode1 = p1.exitCode();
        if(!sys.FileSystem.exists(cxi)) CiaGenerate.makeError("Failure generating CIA archive: CXI build failed");
        else Sys.println(" - CXI data successfully generated: " + cxi);
        var p2 = new sys.io.Process(command2);
        var ecode2 = p2.exitCode();
        if(!sys.FileSystem.exists(output)) CiaGenerate.makeError("Failure generating CIA archive: final build failed");
        else Sys.println(" - Successfully built homebrew CIA archive: " + output);
        sys.FileSystem.deleteFile(cxifle);
    }

    public static function buildDSiWare(Path)
    {
        Sys.println("");
        Sys.println(" - Building DSiWare CIA from: " + Path);
        var pth = new haxe.io.Path(Path);
        pth.ext = "cia";
        var output = pth.toString();
        if(sys.FileSystem.exists(output)) sys.FileSystem.deleteFile(output);
        var command1 : String;
        switch(Sys.systemName())
        {
            case "Windows":
                command1 = "make_cia.exe --srl=\"" + Path + "\"";
            default:
                command1 = "";
        }
        var p1 = new sys.io.Process(command1);
        var ecode = p1.exitCode();
        if(!sys.FileSystem.exists(output)) CiaGenerate.makeError("Failure generating CIA archive: final build failed");
        else Sys.println(" - Successfully built DSiWare CIA archive: " + output);
    }

    public static function clearScreen()
    {
        switch(Sys.systemName())
        {
            case "Windows":
                Sys.command("cls");
            
            /*
            case "Linux":
                Sys.command(" what does linux terminal use to clear screen? ");
            */
        }
    }

    public static function printOver(Text, Spaces = 0)
    {
        Sys.print("\r" + Text);
        if(Spaces > 0) for(i in 0...Spaces) Sys.print(" ");
    }

    public static function makeError(Text)
    {
        Sys.print("\n[Error] " + Text + "\n");
        Sys.print(" CiaGenerate will be closed in 5 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 4 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 3 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 2 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 1 seconds...");
        Sys.sleep(1);
        Sys.exit(0);
    }

    public static function requiredFiles() : Array<String>
    {
        var req = new Array<String>();
        var dir = new haxe.io.Path(Sys.programPath()).dir;
        switch(Sys.systemName())
        {
            case "Windows":
                req = [dir + "\\makerom.exe", dir + "\\cxitool.exe", dir + "\\3dsconv.exe", dir + "\\boot9.bin", dir + "\\make_cia.exe"];
            
            /*
            case "Linux":
                req = [???];
            */
        }
        return req;
    }

    public static function endProgram()
    {
        Sys.print("\nCiaGenerate execution finished.\n");
        Sys.print(" CiaGenerate will be closed in 5 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 4 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 3 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 2 seconds...");
        Sys.sleep(1);
        CiaGenerate.printOver(" CiaGenerate will be closed in 1 seconds...");
        Sys.sleep(1);
        Sys.exit(0);
    }
}