Unit SysLog.Console;
//==============================================================================
//== SysLog Console Base Class                               © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== 08/06/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//== 10/06/2018 Cavicchioli Sergio                                            ==
//== + Aggiunta modalità verbose (solo per modalità console)                  ==
//==                                                                          ==
//==============================================================================

Interface

Uses System.SysUtils, System.DateUtils,
  Console.Base, SysLog.Base;

Type

  TSysLogConsole = Class(TConsoleBase)
  Protected
    FServer : TSysLogBase;
    Procedure ServerStart; override;
    Procedure ServerStop; override;
    Function UCommand( const AString : string ) : Integer; override;
  Public
    Constructor Create;
    Destructor Destroy; override;
  End;

Implementation

//==============================================================================
{ TSysLogConsole }
//==============================================================================
Constructor TSysLogConsole.Create;
Begin
  inherited;

  StAppName := 'SysLog Server';
  StAppVersion := 'V1.0';

  StPrompt := 'SysLog>';

  StLogo := '===============================================================================' + sLineBreak +
            '== SysLog Server V1.0                                       © XP Informatica ==' + sLineBreak +
            '===============================================================================';

  FServer := TSysLogBase.Create;
End;

//==============================================================================
Destructor TSysLogConsole.Destroy;
Begin
  FServer.Free;

  inherited;
End;

//==============================================================================
Procedure TSysLogConsole.ServerStart;
Begin
  inherited;
  FServer.Start;
End;

//==============================================================================
Procedure TSysLogConsole.ServerStop;
Begin
  inherited;
  FServer.Stop;
End;

//==============================================================================
Function TSysLogConsole.UCommand(const AString: string): Integer;
Var
  S, T : String;
  i : Integer;
Begin
  Result := 1;

  If LowerCase(Trim(AString)) = 'exit' then Result := 0;

  If LowerCase(Trim(AString)) = 'help' Then Begin
    WriteMsg( 'help -> Visualizza questo aiuto.');
    WriteMsg( 'exit -> Termina l''applicazione.');
    WriteMsg( 'status -> Visualizza lo stato dell''applicazione.');
    WriteMsg( 'verbose -> Attiva/Disattiva Visualizzazione messaggi di debug.');
  End;

  If LowerCase(Trim(AString)) = 'status' Then Begin
    DateTimeToString(T, 'dd/mm/yyyy hh:mm:ss', FServer.StartTime);
    Writeln( 'Servizio SysLog ' + iif(FServer.Active, 'Attivo dal ' + T , 'Arrestato') );
    Writeln( FServer.CountEvent.ToString + ' Eventi Registrati' );
    for I := 0 to FServer.Server.Bindings.Count-1 do
      Writeln( '  Address ' + FServer.Server.Bindings[i].IP + ' Port ' + FServer.Server.Bindings[i].Port.ToString );
    Writeln( 'DataBase ' + iif(FServer.DbServer.Connected, 'Connesso', 'non Connesso') );
    Writeln( '  ' + FServer.DbServer.Params.Values['Server'] + ':' + FServer.DbServer.Params.Values['DataBase'] );
    Writeln( 'Verbose mode: ' + iif(FServer.Verbose, 'attivo', 'non attivo') );
  End;

  If LowerCase(Trim(AString)) = 'verbose' Then Begin
    FServer.Verbose := Not FServer.Verbose;
    Writeln( 'Verbose mode: ' + iif(FServer.Verbose, 'attivo', 'non attivo') );
  End;

End;

//==============================================================================
End.
