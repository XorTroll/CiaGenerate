
// CiaGenerate Haxe source file: tested under 32bit and 64bit Windows. Needs testing on Linux (I have to build its binaries first)
// Version: 0.4
// Version info: Some bugs fixed, DSiWare build remade
// Now using 'Program' class, under 'xorTroll' package, to make simple operations

class CiaGenerate
{
    public static var Program : xorTroll.Program;

    public static function main()
    {
        CiaGenerate.Program = new xorTroll.Program("CiaGenerate", "Homebrew, DSiWare and retail CIA builder", "0.4", "21st April 2018");
        CiaGenerate.Program.checkArgs(1);
        var input = Sys.args()[0];
        if(!sys.FileSystem.exists(input)) CiaGenerate.Program.makeError("Given file does not exist.");
        CiaGenerate.Program.checkPaths(CiaGenerate.requiredFiles());
        var ext = haxe.io.Path.extension(input).toLowerCase();
        switch(ext)
        {
            case "nds" | "srl":
                CiaGenerate.buildDSiWare(input);
            case "3ds" | "cci":
                CiaGenerate.buildCCI(input);
            case "3dsx":
                CiaGenerate.build3DSX(input);
            default:
                CiaGenerate.Program.makeError("Unknown file format. Must be NDS/SRL, 3DSX or 3DS/CCI.");
        }
        CiaGenerate.Program.endProgram();
    }

    public static function buildCCI(Path)
    {
        Sys.println(" - Building CIA from 3DS/CCI ROM: " + Path);
        var dir = CiaGenerate.Program.programDir();
        var pth = new haxe.io.Path(Path);
        pth.ext = "cia";
        var outdir = pth.dir;
        var output = pth.toString();
        if(sys.FileSystem.exists(output)) sys.FileSystem.deleteFile(output);
        var cmd = "3dsconv --boot9=\"" + dir + "/boot9.bin\" --output=\"" + outdir + "\" \"" + Path + "\"";
        CiaGenerate.Program.executeFileNull(cmd);
        if(!sys.FileSystem.exists(output)) CiaGenerate.Program.makeError("Failure generating CIA archive: final build failed");
        else Sys.println(" - Successfully built CIA archive: " + output);
    }

    public static function build3DSX(Path)
    {
        Sys.println(" - Building homebrew CIA from: " + Path);
        var pth = new haxe.io.Path(Path);
        pth.ext = "cxi";
        var cxifle = pth.toString();
        var cxi = pth.toString();
        pth.ext = "cia";
        var output = pth.toString();
        if(sys.FileSystem.exists(output)) sys.FileSystem.deleteFile(output);
        var cxicmd = "cxitool \"" + Path + "\" \"" + cxi + "\"";
        var ciacmd = "makerom -f cia -o \"" + output + "\" -target t -i \"" + cxi + "\":0:0";
        CiaGenerate.Program.executeFileNull(cxicmd);
        if(!sys.FileSystem.exists(cxi)) CiaGenerate.Program.makeError("Failure generating CIA archive: CXI build failed");
        else Sys.println(" - CXI data successfully generated: " + cxi);
        CiaGenerate.Program.executeFileNull(ciacmd);
        if(!sys.FileSystem.exists(output)) CiaGenerate.Program.makeError("Failure generating CIA archive: final build failed");
        else Sys.println(" - Successfully built homebrew CIA archive: " + output);
        sys.FileSystem.deleteFile(cxifle);
    }

    public static function buildDSiWare(Path)
    {
        Sys.println(" - Building DSiWare CIA from: " + Path);
        var pth = new haxe.io.Path(Path);
        var orext = pth.ext;
        pth.ext = "cia";
        var output = pth.toString();
        pth.ext = orext + ".orig.nds";
        var tmppth = pth.toString();
        pth.ext = "ndsi";
        var outdsi = pth.toString();
        if(sys.FileSystem.exists(output)) sys.FileSystem.deleteFile(output);
        var dsicmd : String;
        var ciacmd = "makerom -srl \"" + outdsi + "\"";
        switch(CiaGenerate.Program.platformName())
        {
            case "Windows":
                dsicmd = "dsiware_patch\\dsiware_patch \"" + Path + "\" ";
            case "Linux":
                dsicmd = "dsiware_patch \"" + Path + "\"";
            default:
                dsicmd = "";
        }
        CiaGenerate.Program.executeFileNull(dsicmd);
        if(!sys.FileSystem.exists(tmppth)) CiaGenerate.Program.makeError("Failure generating CIA archive: DSiWare patch failed");
        else Sys.println(" - Patched DSi ROM successfully generated: " + outdsi);
        sys.FileSystem.rename(Path, outdsi);
        sys.FileSystem.rename(tmppth, Path);
        CiaGenerate.Program.executeFileNull(ciacmd);
        if(!sys.FileSystem.exists(output)) CiaGenerate.Program.makeError("Failure generating CIA archive: final build failed");
        else Sys.println(" - Successfully built DSiWare CIA archive: " + output);
    }

    public static function requiredFiles() : Array<String>
    {
        var req = new Array<String>();
        var dir = new haxe.io.Path(Sys.programPath()).dir;
        switch(CiaGenerate.Program.platformName())
        {
            case "Windows":
                req = [dir + "/makerom.exe", dir + "/cxitool.exe", dir + "/3dsconv.exe", dir + "/boot9.bin", dir + "/dsiware_patch"];
            
            case "Linux":
                req = [dir + "/makerom", dir + "/cxitool", dir + "/3dsconv", dir + "/boot9.bin", dir + "/dsiware_patch"];
        }
        return req;
    }
}