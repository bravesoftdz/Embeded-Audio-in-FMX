program EmbededAudio;

uses
  System.StartUpCopy,
  System.iOUtils,
  System.SysUtils,
  system.Classes,
  System.Types,
  FMX.Media,
  FMX.Forms,
  UMain in 'UMain.pas' {FrmMain};

{$R *.res}
{$IFDEF MSWINDOWS}
  {$R Embeded_MP3.RES}
{$ENDIF}

const
  Android_Audio = 'Embeded_OGG.ogg';
  IOS_Audio = 'Embeded_CAF.CAF';
  MSWindows_Audio = 'Embeded_MP3.MP3'; ResName_ForMSWINDOWS = 'EMBEDED_MP3';

//  for more Infos Plz go here : http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Audio-Video_in_FireMonkey
// or http://docwiki.embarcadero.com/CodeExamples/Tokyo/en/FMX.PlayAudioFile_Sample

var
 MPlayer: TMediaPlayer;

{$Region 'My Special Functions'}

procedure Extract_EmbedAudio;
var
  ResStream : TResourceStream; // Resource Stream object
begin
  try
    ResStream := TResourceStream.Create(HInstance, ResName_ForMSWINDOWS, RT_RCDATA);
    ResStream.SaveToFile(TPath.Combine(TPath.GetTempPath, MSWindows_Audio));
  finally
    ResStream.Free;
  end;
end;

function SetMusicFileName(const AFileName: string): string;
begin
{$IFDEF ANDROID}
 // Result := TPath.GetTempPath + '/' + AFileName;
  Result := TPath.GetDocumentsPath + PathDelim + AFileName;
{$ELSE}
  {$IFDEF IOS}
    Result := TPath.GetHomePath + '/Documents/' + AFileName;
  {$ELSE}
    Extract_EmbedAudio;
    Result := TPath.Combine(TPath.GetTempPath, AFileName);
  {$ENDIF}
{$ENDIF}
end;

procedure Play_EmbedAudio;
begin
  if MPlayer = nil then
  begin
   MPlayer := TMediaPlayer.Create(Application);
  end;
  try
   {$IFDEF ANDROID}
      MPlayer.FileName := SetMusicFileName(Android_Audio);
   {$ELSE}
    {$IFDEF IOS}
       MPlayer.FileName := SetMusicFileName(IOS_Audio); // here i haven't an ios so i can't try to convert the audio into a caf extenssion ...
       {$ELSE}
          MPlayer.FileName := SetMusicFileName(MSWindows_Audio);
    {$ENDIF}
  {$ENDIF}
  finally
   MPlayer.Media.Play;
   MPlayer.Volume := 50;
  end;
end;

procedure Start_Audio;
begin
  MPlayer := TMediaPlayer.Create(Application);
  MPlayer.Name := 'MPlayer_Embeded';
  Play_EmbedAudio;
end;

//procedure OnFinishAPP;
//begin
//  MPlayer.Free;
//end;

{$endregion}

begin
  Application.Initialize;
  Start_Audio;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
