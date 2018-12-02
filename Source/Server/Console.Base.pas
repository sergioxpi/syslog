Unit Console.Base;
//==============================================================================
//== Application Console Base Class                          © XP Informatica ==
//==                         Realizzato da Cavicchioli Sergio - sergio@xpi.it ==
//==============================================================================
//== 06/06/2018 Cavicchioli Sergio                                            ==
//== + Realizzazione                                                          ==
//==                                                                          ==
//==============================================================================

Interface

Uses System.SysUtils
  {$IFDEF LINUX}
   , WiRL.Console.Posix.Daemon
  {$ENDIF}
  ;

Type
  TConsoleBase = Class(TObject)
  Protected
    StAppName : String;
    StAppVersion : String;
    StPrompt : String;
    StLogo : String;
    Procedure ServerStart; virtual; abstract;
    Procedure ServerStop; virtual; abstract;
    Function UCommand( const AString : string ) : Integer; virtual; abstract;
  Public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Start;
    Class Procedure WriteMsg(const AMessage: string);
  End;

  Function iif(Condition: Boolean; V1, V2: Variant): Variant;

Implementation

//==============================================================================
Function iif(Condition: Boolean; V1, V2: Variant): Variant;
Begin
  If (Condition) Then Result := V1 Else Result := V2;
End;

//==============================================================================
{ TConsoleBase }
//==============================================================================
Constructor TConsoleBase.Create;
Begin
  StAppName := 'MyApplication';
  StAppVersion := 'V1.0';
  StPrompt := '>';
  StLogo := '===============================================================================' + sLineBreak +
            '== Console Application                                                       ==' + sLineBreak +
            '===============================================================================';
End;

//==============================================================================
Destructor TConsoleBase.Destroy;
Begin

  inherited;
End;

//==============================================================================
Procedure TConsoleBase.Start;
Var
  S : string;
  LRun : Integer;
Begin

{$IFDEF LINUX}
  {$IFDEF DAEMON}
  TPosixDaemon.Setup(
    procedure (ASignal: TPosixSignal)
    begin
      case ASignal of
        TPosixSignal.Termination:
        begin
          ServerStop;
        end;

        TPosixSignal.Reload:
        begin
          ServerStop;
          ServerStart;
        end;
      end;
    end
  );

  TPosixDaemon.LogInfo(StAppName + ' ' + StAppVersion + ' Daemon is running...');
  ServerStart;
  TPosixDaemon.Run(1000);
  Exit;
  {$ENDIF}
{$ENDIF}

  ServerStart;

  WriteMsg(StLogo);

  LRun := 1;
  While LRun > 0 do Begin

    Write( StPrompt );

    Readln(S);
    LRun := UCommand(S);

  End;
End;

//==============================================================================
Class Procedure TConsoleBase.WriteMsg(const AMessage: string);
Begin
{$IFDEF LINUX}
  {$IFDEF DAEMON}
    TPosixDaemon.LogInfo( AMessage );
  {$ELSE}
    Writeln( AMessage );
  {$ENDIF}
{$ELSE}
  Writeln( AMessage );
{$ENDIF}
End;

//==============================================================================
End.
