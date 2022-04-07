Rem eNB Analytics "Fancy Edition"
Rem Version du 1er avril 2020
Rem Licence: open source

_Title "eNB Analytics 5.0"
Screen _NewImage(800, 600, 256)

Call INITSCREEN '閏ran de d閙arrage. Optionnel
Call DISPLAYMAP
Call TOOLBAR

'test affichage points
'CALL DISPLAYPT(48.28, -4.62, 14) 'ouest
'CALL DISPLAYPT(48.95, 8.17, 12) 'Alsace nord
'CALL DISPLAYPT(43.08, 6.14, 9) 'Hy鑢es
'CALL DISPLAYPT(51.05, 2.38, 10) 'Dunkerque

'boucle syst鑝e
Do
    _Limit 30 'limits the rate of the loop to 30 frames per second.
    kbd$ = InKey$
    If kbd$ = "a" Or kbd$ = "A" Then
        Locate 37, 1
        Print "utilisez les touches i, m et r pour acc" + Chr$(130) + "der aux fonctions"
    End If

    If kbd$ = "i" Or kbd$ = "I" Then
        Call IMPORT
    End If

    If kbd$ = "m" Or kbd$ = "M" Then
        Call MANUEL
    End If

    If kbd$ = "r" Or kbd$ = "R" Then
        Call SEARCH
    End If

    If kbd$ = Chr$(27) Then
        System
    End If
Loop Until kbd$ = Chr$(27) 'CHR$(27) is the ESC key.


Sub DISPLAYMAP
    Cls
    Print ""
    Print "                                                    `-`"
    Print "                                                 /:-.`+--`"
    Print "   eNB Analytics                                `/       /-"
    Print "                                                -:        `:-:."
    Print "                                               -/`            s-/o"
    Print "                               `:--`      `::--`                 ::-"
    Print "                               ./  o     -/                        `:----:-"
    Print "                                :- `----::`                               -/::::-."
    Print "                       `--`      o                   " + Chr$(254) + "                           `s"
    Print "                `:--::::  /----::s`                                             `+`"
    Print "                 /o-                                                            o"
    Print "                  +:-:.                                                         +"
    Print "                      `:+-:`                                                   `o"
    Print "                         ``+-                                                s--"
    Print "                            .o.                                            ./`"
    Print "                            `o:                                           /-"
    Print "                              :-                                         :-``"
    Print "                               -::.                                     `s/..+"
    Print "                                 -o.                                    .-   :-"
    Print "                                 +/`                                         :/"
    Print "                                  /:`                                         /-"
    Print "                                  o:y`                                       -:/"
    Print "                                  + ``                                      `+-"
    Print "                                 //                                           .+"
    Print "                                 ::                                           o"
    Print "                                 o                                            `:--:`"
    Print "                                -:                                               ./."
    Print "                                o                                              `/-"
    Print "                              ./`                            -::::--:-       .::"
    Print "                              .:+                         .::`    `` .::-`-::."
    Print "                                -::--                    /-             `-`               `"
    Print "                                    .--/-:-::--:..       o                                o+"
    Print "                                                ../-.-`--+:                            `:/.+"
    Print "                                                   `. .`                              +-   +"
End Sub

Sub INITSCREEN
    Cls
    Locate 17, 40
    Print "eNB Analaytics v5.0"
    Locate 18, 40
    Print "   "; Chr$(34); "Reactivated"; Chr$(34)
    Locate 20, 40
    Print " enb-analytics.fr"
    Locate 35, 18
    Print "P 2020 - eNB Analytics"
    For j = 18 To 80
        _Delay (0.04)
        Locate 32, j
        Print Chr$(254)
        Locate 31, 18
        Print "Chargement..."
    Next j
    Locate 31, 18
    Print "OK            "
    Beep
    _Delay (0.8)
End Sub

Sub TOOLBAR
    Locate 36, 1
    Color 15, 0
    Print "A"
    Color 15, 3
    Locate 35, 3
    Print "Aide       "
    Color 15, 0
    Locate 35, 15
    Print "  I"
    Color 15, 3
    Locate 35, 19
    Print "Import NTM "
    Color 15, 0
    Locate 35, 31
    Print "  M"
    Color 15, 3
    Locate 35, 35
    Print "Ajt Manuel "
    Color 15, 0
    Locate 35, 47
    Print "  R"
    Color 15, 3
    Locate 35, 51
    Print "Rechercher "
    Color 15, 0
    Locate 35, 63
    Print "  Esc"
    Color 15, 3
    Locate 35, 69
    Print "Quitter    "
    Color 15, 0
End Sub


Sub DISPLAYPT (x, y, col)
    Color col
    Locate GetLat(x), GetLon(y)
    Print "A"
    Color 15
End Sub

Function GetLat (x)
    'renvoie des donn閑s entre 0 et 35
    xa = x - (2 * x) 'inverse
    GetLat = ((xa + 52) * 3.8) - 3
End Function

Function GetLon (y)
    'renvoie des donn閑s entre 16 et 84
    ya = y + 5 'ajouter 5 pour 関iter les coordonn閑s n間atives
    GetLon = (ya * 5.23) + 15
End Function



Sub MANUEL
    Cls
    Locate 17, 1
    Input "Latitude : ", mLat!
    Input "Longitude : ", mLon!
    If mLat! > 42 And mLat! < 53 Then
        If mLon! > -5 And mLon! < 8 Then
            Call DISPLAYMAP
            Call DISPLAYPT(mLat!, mLon!, 12)
            Call TOOLBAR
            Locate 18, 4
            Print "Ajout"; Chr$(130); ":"
            Locate 19, 3
            Print mLat!; " "; mLon!
        Else
            Beep
            Print "Longitude incorrecte"
            Sleep 3
            Call DISPLAYMAP
            Call TOOLBAR
        End If
    Else
        Beep
        Print "Latitude incorrecte"
        Sleep 3
        Call DISPLAYMAP
        Call TOOLBAR
    End If
End Sub



'methode qui v閞ifie si un fichier existe
'TODO: ne fonctionne pas si un 関entuel sous-dossier n'閤iste pas
Function Exist% (filename$)
    f% = FreeFile
    Open filename$ For Append As #f%
    If LOF(f%) Then Exist% = -1 Else Exist% = 0: Close #f%: Kill filename$ 'delete empty files
    Close #f%
End Function


'import de fichier NetMonster
Sub IMPORT
    Dim NbLigne As Integer
    Dim NbJunk As Integer
    Dim NbPart As Integer
    Locate 36, 1
    Input "Nom du fichier a importer: ", fichier$
    Call DISPLAYMAP
    Call TOOLBAR

    'tester la presence du fichier
    If Exist%(fichier$) Then
        GoTo 10
    Else
        Locate 36, 1
        Print "Fichier "; fichier$; " introuvable"
        Sleep 2
        Call DISPLAYMAP
        Call TOOLBAR
        GoTo 20
    End If

    10
    Open fichier$ For Input As #1
    Do While Not EOF(1) 'tant que la fin du fichier n'est pas atteinte
        NbLigne = NbLigne + 1 'commencer le comptage des ligne a 1 et non 0
        Line Input #1, Ligne$

        Dim FirstPart$
        Length = Len(Ligne$) ' nombre de caract猫res sur la ligne.
        NbPart = 0
        Dim lat!
        Dim lon!
        Dim mnc!

        For K = 1 To Length
            'loop through the characters of the string up to the ; character
            Char1$ = Mid$(Ligne$, K, 1) ' get a character from the string
            'Test for valid binary digit.
            If Char1$ = ";" Then
                'PRINT "Ligne "; NbLigne; " Part "; NbPart; " = "; FirstPart$

                If NbPart = 7 Then
                    lat = Val(FirstPart$)
                End If
                If NbPart = 8 Then
                    lon = Val(FirstPart$)
                End If
                If NbPart = 2 Then
                    mnc = Val(FirstPart$)
                End If

                FirstPart$ = "" 'reset
                NbPart = NbPart + 1
            Else
                FirstPart$ = FirstPart$ + Char1$ ' add 1 character to the end of the first part
            End If
        Next

        If lat > 40.0 Then
            If mnc = 20 Then
                couleur = 9 'bleu
            ElseIf mnc = 15 Then
                couleur = 13 'violet
            ElseIf mnc = 1 Then
                couleur = 14 'jaune
            Else
                couleur = 12 'rouge
            End If
            Call DISPLAYPT(lat, lon, couleur)
        Else
            NbJunk = NbJunk + 1
        End If
        FirstPart$ = "" 'reset
    Loop
    Close #1 'fermer le fichier

    Locate 17, 4
    Print "Termin"; Chr$(130)
    Locate 18, 3
    Print NbLigne; " lignes lues"
    Locate 19, 3
    Print NbJunk; " lignes ignor"; Chr$(130); "es"
    20
End Sub


'Rechercher dans MLS
Sub SEARCH
    Cls
    Call DISPLAYMAP
    Call TOOLBAR

    Locate 17, 1
    Print "Recherche"
    Locate 18, 1
    Print "                   "
    Locate 19, 1
    Print "                   "
    Locate 18, 1
    Input "PLMN : ", plmn$
    Locate 19, 1
    Input "eNB  : ", enb&

    fichier2$ = "MLS\MLS_" + plmn$ + "_LTE.csv"

    'tester la presence du fichier
    If Exist%(fichier2$) Then
        GoTo 30
    Else
        Locate 20, 1
        Print "Fichier "; fichier2$; " introuvable"
        Sleep 4
        Call DISPLAYMAP
        Call TOOLBAR
        GoTo 40
    End If

    30
    Dim couleur As Integer
    If Val(plmn$) = 20820 Then
        couleur = 9
    ElseIf Val(plmn$) = 20815 Then
        couleur = 13
    ElseIf Val(plmn$) = 20801 Then
        couleur = 14 'jaune
    Else
        couleur = 12
    End If

    Open fichier2$ For Input As #2
    Do While Not EOF(2) 'tant que la fin du fichier n'est pas atteinte
        NbLigne = NbLigne + 1 'commencer le comptage des ligne a 1 et non 0
        Line Input #2, Ligne$

        Dim FirstPart$
        Length = Len(Ligne$) ' nombre de caract猫res sur la ligne.
        NbPart = 0
        Dim lat!
        Dim lon!
        Dim latS!
        Dim lonS!
        Dim enb2 As Long
        Dim cid As Integer
        Dim tac As Long
        Dim matches As Integer

        For K = 1 To Length
            'loop through the characters of the string up to the ; character
            Char1$ = Mid$(Ligne$, K, 1) ' get a character from the string
            If Char1$ = "," Then
                'PRINT "Ligne "; NbLigne; " Part "; NbPart; " = "; FirstPart$

                If NbPart = 4 Then
                    enb2 = Val(FirstPart$)
                    enb2 = enb2 / 256
                    cid = Val(FirstPart$) - (enb2 * 256)
                End If

                If NbPart = 3 Then
                    tac = Val(FirstPart$)
                End If

                If NbPart = 7 Then
                    lat = Val(FirstPart$)
                End If
                If NbPart = 6 Then
                    lon = Val(FirstPart$)
                End If

                FirstPart$ = "" 'reset
                NbPart = NbPart + 1
            Else
                FirstPart$ = FirstPart$ + Char1$ ' add 1 character to the end of the first part
            End If
        Next

        If enb2 = enb& Then
            latS = lat
            lonS = lon
            Print "Trouv"; Chr$(130); " CID"; cid; " TAC"; tac
            matches = matches + 1
        End If
        FirstPart$ = "" 'reset
    Loop
    Close #2 'fermer le fichier
    Print "Termin"; Chr$(130); ":"; matches; "CID ajout"; Chr$(130); "s"

    If matches > 0 Then
        Call DISPLAYPT(latS, lonS, couleur)
    End If
    40
End Sub
