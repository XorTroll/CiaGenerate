
#include <Opuka.h>

#define version "0.2"
#define date "20th February 2018"

void Error(string Description)
{
	MessageBox(GetConsoleWindow(), string(Description + "\nClosing program...").c_str(), "CiaGenerate - Runtime error", MB_ICONERROR);
	exit(0);
}

void Success(string Description)
{
	MessageBox(GetConsoleWindow(), string(Description + "\nClosing program...").c_str(), "CiaGenerate - Operation succeeded!", MB_ICONINFORMATION);
	exit(0);
}

int main(int argc, entryargs argv)
{
	system("title CiaGenerate v0.2: DSiWare, homebrew and retail CIA generator");
	cout << endl << "   " << "CiaGenerate converting tool" << endl << endl;
	cout << "   " << "Copyright (C) 2018, made by XorTroll developing" << endl;
	cout << "   " << "Version: v" << version << ", built on " << date << endl;
	string input;
	if (argc < 2) Error("No files were given.\nThis program must be opened with input ROMs:\nNDS or SRL, 3DS or CCI and 3DSX ROMs.");
	input = argv[1];
	string ext = GetExtension(input);
	if (!Exists(Cwd(argv) + "\\makerom.exe") or !Exists(Cwd(argv) + "\\cxitool.exe") or !Exists(Cwd(argv) + "\\3dsconv.exe") or !Exists(Cwd(argv) + "\\boot9.bin") or !Exists(Cwd(argv) + "\\make_cia.exe")) Error("Required executables were not found.");
	cout << endl << "   " << "---------------------------------------------------------------" << endl << endl;
	if (ext is "nds" or ext is "srl")
	{
		cout << " - [System] Starting build of DSiWare CIA archive..." << endl;
		NullExec(Cwd(argv) + "\\make_cia --srl=\"" + input + "\"");
		if (Exists(TrimExtension(input) + ".cia"))
		{
			cout << " - [Build] Done!" << endl;
			cout << " - [System] Press any key to close CiaGenerate.";
			system("pause > nul 2> nul");
		}
		else Error("Failed to generate DSiWare CIA from NDS - SRL ROM.");
	}
	else if (ext is "3dsx")
	{
		cout << " - [System] Starting build of homebrew CIA archive..." << endl;
		NullExec(Cwd(argv) + "\\cxitool \"" + input + "\" \"" + TrimExtension(input) + ".cxi\"");
		if (Exists(TrimExtension(input) + ".cxi"))
		{
			NullExec(Cwd(argv) + "\\makerom -f cia -o \"" + TrimExtension(input) + ".cia\" -target t -i \"" + TrimExtension(input) + ".cxi\":0:0x00");
			if (Exists(TrimExtension(input) + ".cia"))
			{
				remove((TrimExtension(input) + ".cxi").c_str());
				cout << " - [Build] Done!" << endl;
				cout << " - [System] Press any key to close CiaGenerate.";
				system("pause > nul 2> nul");
			}
			else Error("Failed to generate CIA from 3DSX homebrew ROM.");
		}
		else Error("Failed to generate CXI temporary partition from 3DSX homebrew ROM.");
	}
	else if (ext is "3ds" or ext is "cci")
	{
		cout << " - [System] Starting build of retail CIA archive..." << endl;
		NullExec(Cwd(argv) + "\\3dsconv --boot9=\"" + Cwd(argv) + "\\boot9.bin\" \"" + input + "\"");
		if (Exists(TrimExtension(input) + ".cia"))
		{
			cout << " - [Build] Done!" << endl;
			cout << " - [System] Press any key to close CiaGenerate.";
			system("pause > nul 2> nul");
		}
		else Error("Failed to generate CIA from 3DS ROM.");
	}
	else if (ext is "cia") Error("Why would you want to convert a CIA to a CIA?");
	else Error("An unknown file was given.\nTry one of these:\n\nNDS or SRL, 3DS or CCI and 3DSX ROMs.");
	return 0;
}