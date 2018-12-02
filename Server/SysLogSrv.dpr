Program SysLogSrv;
//==============================================================================
//== SysLog Server Console Application                       © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== 31/05/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//==============================================================================

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.DateUtils,
  SysLog.Base in '..\Source\Server\SysLog.Base.pas',
  Console.Base in '..\Source\Server\Console.Base.pas',
  SysLog.Console in '..\Source\Server\SysLog.Console.pas';

Var
  LServer : TSysLogConsole;

//==============================================================================
Begin
  ReportMemoryLeaksOnShutdown := True;

  Try

    LServer := TSysLogConsole.Create;
    Try

      Try
        LServer.Start;
      Except
        On E: Exception Do Begin
          ExitCode := 1;
          TConsoleBase.WriteMsg(E.ClassName + ': ' + E.Message);
        End;
      End;

    Finally
      LServer.Free;
    End;

  Except
    On E: Exception Do Begin
      ExitCode := 1;
      TConsoleBase.WriteMsg(E.ClassName + ': ' + E.Message);
    End;
  End;

//==============================================================================
End.
