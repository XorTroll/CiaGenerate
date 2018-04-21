package xorTroll;

class Program
{
    public var Title(default, default) : String;
    public var Description(default, default) : String;
    public var Version(default, default) : String;
    public var BuildDate(default, default) : String;

    public function new(Title, Description, Version, BuildDate)
    {
        this.Title = Title;
        this.Description = Description;
        this.Version = Version;
        this.BuildDate = BuildDate;
        this.makeStartup();
    }

    public function programDir() return haxe.io.Path.directory(Sys.programPath());

    public function processedName() return this.Title + ": " + this.Description;

    public function platformName() return Sys.systemName();

    public function stringContains(Main, Sub) return Main.indexOf(Sub) >= 0;

    public function rePrint(Text) Sys.print("\r" + Text);

    public function setTitle(Title)
    {
        var cmd : String;
        switch(this.platformName())
        {
            case "Windows":
                cmd = "title " + Title;
            default:
                cmd = "";
        }
        Sys.command(cmd);
    }

    public function executeFile(Command)
    {
        var cmd : String;
        switch(this.platformName())
        {
            case "Windows":
                cmd = Command;
            case "Linux":
                cmd = "./" + Command;
            default:
                cmd = "";
        }
        var prc = new sys.io.Process(cmd);
        var ecode = prc.exitCode();
    }

    public function checkPaths(Paths : Array<String>) for(p in Paths) if(!sys.FileSystem.exists(p)) this.makeError("Required file/directory was not found: " + p + ".");

    public function checkArgs(ArgNumber) if(Sys.args().length != ArgNumber) this.makeError("Too many or too few arguments were given (Required arguments: " + ArgNumber + ")");

    public function executeFileNull(Command)
    {
        var cmd : String;
        switch(this.platformName())
        {
            case "Windows":
                cmd = Command + " > nul 2> nul";
            case "Linux":
                cmd = "./" + Command + " > nul";
            default:
                cmd = "";
        }
        var prc = new sys.io.Process(cmd);
        var ecode = prc.exitCode();
    }

    public function makeStartup()
    {
        this.setTitle(this.processedName());
        Sys.setCwd(this.programDir());
        Sys.println("");
        Sys.println(" ----- " + this.processedName() + " ----- ");
        Sys.println("");
        Sys.println(" --- Copyright (C) 2018, by XorTroll");
        Sys.println(" --- Version: v" + this.Version + ", built on " + this.BuildDate);
        Sys.println(" --- Made using Haxe, compiled to executable binary");
        Sys.println("");
    }

    public function makeError(Error)
    {
        Sys.println("");
        Sys.println(" - ERROR: " + Error);
        Sys.print(" - " + this.Title + " will be closed in 5 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 4 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 3 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 2 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 1 seconds...");
        Sys.sleep(1);
        this.rePrint("   Exiting program...");
        Sys.exit(0);
    }

    public function endProgram()
    {
        Sys.println("");
        Sys.println(" - " + this.Title + "\'s execution finished.");
        Sys.print(" - " + this.Title + " will be closed in 5 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 4 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 3 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 2 seconds...");
        Sys.sleep(1);
        this.rePrint(" - " + this.Title + " will be closed in 1 seconds...");
        Sys.sleep(1);
        this.rePrint(" - Exiting program...                                                ");
        Sys.println("");
        Sys.exit(0);
    }
}