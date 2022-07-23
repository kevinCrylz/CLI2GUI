{Munsang College  Yeung Yu Ching 6A 25}
Program ThemePark_System;
Uses crt, sysutils, windows;

Const db_loc = '.\'; { **  Location of 'ReadMe' and 'Database' file  ** }
                {'C:\users\desktop\'}    { **  Sample  ** }

Var ch_menuX, ch_menuY, pre_menuX, pre_menuY, no_disQuo, no_schelu, key, key_menu, i : integer;
    ok_readme, style : string;
    user_name, pass_word : string[24];
    no_disct : array[1..6] of integer;
    fac_ftps, res_book, data_schelu : array[1..14] of string;
    draw_box, draw_menu, logn, on_wifi, on_gps, on_nfc, remind_disct : boolean;
    schelu_event : array[1..20] of boolean;
    readme, db_disct, db_mapA, db_mapB, db_facils, db_event, db_restnt, db_schelu : text;

{Layout}
Procedure Layout;
Var color_wifi, color_gps, color_nfc, i : integer;
    DD, MM, YY : word;
Begin
     textcolor(11);
     textbackground(16);

     {Box}
     if draw_box then
     begin
          clrscr;

          GoToXY(2,2);
          for i := 1 to 38 do write(' ',style);
          writeln;

          for i := 1 to 21 do writeln('  ',style,' ':73,style);

          GoToXY(2,24);
          for i := 1 to 38 do write(' ',style);

          GoToXY(2,6);
          for i := 1 to 38 do write(' ',style);

          for i := 1 to 3 do
          begin
               GoToXY(51,2 + i);
               write(style);
               end;

          draw_box := false;
          end
     else begin
               for i := 1 to 17 do
               begin
                    GoToXY(4,6 + i);
                    write(' ':73);
                    end;
               end;

     {Status Box}
     for i := 1 to 3 do
     begin
          textcolor(14);
          textbackground(13);

          GoToXY(4,2 + i);
          write(' ':47);
     end;

     GoToXY(8,4);
     write(user_name);

     Randomize;

     color_wifi := (random(2) + 5) * 2;
     color_gps := (random(2) + 5) * 2;
     color_nfc := (random(2) + 5) * 2;

     TextColor(color_WiFi);
     GoToXY(30,3);
     if on_wifi then write('WiFi') else  write('    ');

     TextColor(color_GPS);
     GoToXY(38,3);
     if on_gps then write('GPS') else  write('   ');

     TextColor(color_NFC);
     GoToXY(46,3);
     if on_nfc then write('NFC') else  write('   ');

     {Date Box}
     DeCodeDate(Date,YY,MM,DD);

     for i := 1 to 3 do
     begin
          textcolor(14);
          textbackground(10);

          GoToXY(52,2 + i);
          write(' ':25);
     end;

     GoToXY(59,3);
     write(format('Date : %d/%d/%d ',[DD,MM,YY]));

     GoToXY(59,4);
     writeln('Time : ',TimeToStr(Time));

     textcolor(14);
     textbackground(16);

     GoToXY(80,25);
End;

Procedure login;                                                                {Login}
Var count, key_login, i : integer;
    code_ver_gn, code_ver : string;
    username, password : string[24];
    relogin, verify : boolean;
Begin
     key := 0;
     key_login := 0;
     relogin := true;
     verify := true;
     code_ver_gn := '';
     count := 0;

     Layout;

     if not on_wifi then
     begin
          textColor(14);

          GoToXY(27,9);
          writeln('Please turn on WiFi to login.');

          GoToXY(26,11);
          writeln('[ Press any key to continue ]');

          GoToXY(80,25);

          ReadKey;
          end
     else while (key <> 27) and (key_login <> 8) do
          begin
               TextColor(14);

               GoToXY(36,11);
               writeln('User Login');

               GoToXY(29,15);
               writeln('[ Press ''Enter'' to login ]');

               GoToXY(80,25);

               key_login := ord(readkey);
               key := key_login;

               case key_login of
               13 : begin
                         while relogin do {1st while}
                         begin
                              relogin := false;

                              Layout;

                              TextColor(14);

                              GoToXY(36,11);
                              writeln('User Login');

                              GoToXY(27,14);
                              writeln('User Name : ');

                              GoToXY(27,16);
                              writeln('Password  : ');

                              if count > 1 then
                              begin
                                   GoToXY(19,18);
                                   write('Verification code : ');

                                   randomize;

                                   for i := 1 to 5 do code_ver_gn := code_ver_gn + chr(random(26) + 97);

                                   write('           (       )');

                                   textcolor(13);

                                   GoToXY(52,18);
                                   write(code_ver_gn);
                                   end;

                              TextColor(15);

                              GoToXY(40,14);
                              readln(username);

                              GoToXY(40,16);
                              readln(password);

                              if count > 1 then
                              begin
                                   GoToXY(40,18);
                                   readln(code_ver);
                              end;

                              TextColor(14);

                              GoToXY(26,22);
                              write('[ Press ''Enter'' to confirm ]');

                              Delay(500);

                              GoToXY(40,16);
                              for i := 1 to length(Password) do write('*');

                              GoToXY(80,25);

                              while (key <> 27) and (key_login <> 8) and (relogin <> true) do {2nd while}
                              begin
                                   key_login := ord(readkey);
                                   key := key_login;

                                   case key_login of
                                   13 : begin
                                             if count > 1 then
                                                  if code_ver <> code_ver_gn then verify := false;

                                             if (length(username) = 0) or (length(Password) = 0) or (not verify) then
                                             begin
                                                  code_ver_gn := '';
                                                  relogin := true;
                                                  verify := true;

                                                  count := count + 1;

                                                  Layout;

                                                  TextColor(14);

                                                  if (length(username) = 0) or (length(Password) = 0) then
                                                  begin
                                                       GoToXY(28,9);
                                                       writeln('Invalid Username or Password.');

                                                       GoToXY(28,11);
                                                       writeln('[ Press any key to continue ]');
                                                       end
                                                  else begin
                                                            GoToXY(28,9);
                                                            writeln('Incorrrect Verification Code.');

                                                            GoToXY(28,11);
                                                            writeln('[ Press any key to continue ]');
                                                            end;

                                                  username := '';
                                                  password := '';

                                                  GoToXY(80,25);

                                                  ReadKey;
                                                  end
                                             else begin
                                                       Logn := false;
                                                       user_name := 'Hi, ' + username;
                                                       pass_word := password;

                                                       remind_disct := true;
                                                       no_disQuo := 3;
                                                       for i := 1 to 6 do no_disct[i] := 0;

                                                       rewrite(db_schelu);

                                                       key := 27;
                                                       end;
                                             end;
                                      end; {case}

                              end; {2nd while}

                         end; {1st while}

                         end; {case}
                  end;
          end;
End;

Procedure discount;                                                             {Discount}
Var key_discount, opt, i : integer;
    ch_disct : array[1..6] of string;
Begin
     key := 0;
     key_discount := 0;
     opt := 1;

     reset(db_disct);

     for i := 1 to 6 do readln(db_disct, ch_disct[i]);

     Layout;

     GoToXY(8,9);
     write('Discount');

     GoToXY(26,9);
     write('( Remaining quota :   )');

     GoToXY(11,22);
     write('Press ''Enter'' to confirm');

     while (key <> 27) and (key_discount <> 8) do
     begin
          textcolor(13);

          GoToXY(46,9);
          write(no_disQuo);

          for i := 1 to 6 do
          begin
               textcolor(14);
               textbackground(16);

               GoToXY(60,11 + i);
               writeln('( ',no_disct[i],' )');

               textcolor(11);

               if opt = i then textbackground(9)
               else textbackground(16);

               GoToXY(12,11 + i);
               writeln('    ',i,' :  ',ch_disct[i],' ':26 - length(ch_disct[i]));

               if opt = i then textcolor(14)
               else textcolor(16);

               textbackground(16);

               GoToXY(10,11 + i);
               write('>');

               GoToXY(50,11 + i);
               write('<');
          end;

          GoToXY(80,25);

          key_discount := ord(readkey);
          key := key_discount;

          case key_discount of
          13 : if no_disQuo = 0 then messagebox(0,'You don''t have any quota left','Warning',MB_OK + MB_ApplModal + MB_IconWarning)
                      else if messagebox(0,'Confirm ?','Reminder',MB_YesNo + MB_ApplModal + MB_DefButton2 + MB_IconQuestion) = IDYes then
                           begin
                                no_disQuo := no_disQuo - 1;
                                no_disct[opt] := no_disct[opt] + 1;

                                messagebox(0,'Successfully obtained','Reminder',MB_OK + MB_ApplModal + MB_IconInformation);
                                end;
          72 : if opt > 1 then opt := opt - 1;
          80 : if opt < 6 then opt := opt + 1;
             end;
     end;

     close(db_disct);
End;

Procedure userinfo;
Const no_userinfo = 2;
Var key_userinfo, opt, i : integer;
    name, pass_old, pass_new, pass_conf : string[24];
    ch_userinfo : array[1..no_userinfo] of string;
Begin
     key := 0;
     key_userinfo := 0;
     opt := 1;
     ch_userinfo[2] := '';

     ch_userinfo[1] := user_name;
     delete(ch_userinfo[1],1,4);
     for i := 1 to length(pass_word) do
     ch_userinfo[2] := ch_userinfo[2] + '*';

     Layout;

     GoToXY(8,9);
     write('User Information');

     GoToXY(12,12);
     write('Nick Name');

     GoToXY(12,14);
     write('Change Password');

     GoToXY(11,22);
     write('Press ''Space Bar'' to modify');

     while (key <> 27) and (key_userinfo <> 8) do
     begin
          for i := 1 to no_userinfo do
          begin
               textcolor(11);
               textbackground(16);

               if opt = i then textcolor(14)
               else textcolor(16);

               GoToXY(40,10 + 2 * i);
               write('>','<':29);

               if opt = i then textbackground(9)
               else textbackground(16);

               GoToXY(42,10 + 2 * i);
               write(' ':26);

               textcolor(11);

               GoToXY(42 + (13 - length(ch_userinfo[i]) div 2),10 + 2 * i);
               write(ch_userinfo[i]);
          end;

          GoToXY(80,25);

          key_userinfo := ord(readkey);
          key := key_userinfo;

          case key_userinfo of
          32 : begin
               case opt of
               1 : begin
                        textbackground(9);

                        GoToXY(42,12);
                        write(' ':26);

                        GoToXY(43,12);
                        readln(name);

                        user_name := 'Hi, ' + name;
                        ch_userinfo[1] := name;

                        textcolor(14);
                        textbackground(13);

                        GoToXY(8,4);
                        write(user_name,' ':(24 - length(user_name)));
                        end;
               2 : begin
                        textcolor(14);
                        textbackground(16);

                        GoToXY(27,16);
                        write('Old Password');

                        GoToXY(27,18);
                        write('New Password');

                        GoToXY(23,20);
                        write('Confirm Password');

                        textcolor(15);

                        GoToXY(42,16);
                        readln(pass_old);

                        GoToXY(42,18);
                        readln(pass_new);

                        GoToXY(42,20);
                        readln(pass_conf);

                        if pass_old <> pass_word then messagebox(0,'Wrong password','Warning',MB_OK + MB_ApplModal + MB_IconWarning);
                        if pass_new <> pass_conf then messagebox(0,'Password does not match','Warning',MB_OK + MB_ApplModal + MB_IconWarning);

                        if (pass_old = pass_word) and (pass_new = pass_conf) then
                        begin
                             ch_userinfo[2] := '';

                             messagebox(0,'Password changed','Reminder',MB_OK + MB_ApplModal + MB_IconInformation);
                             pass_word := pass_new;

                             for i := 1 to length(pass_word) do
                             ch_userinfo[2] := ch_userinfo[2] + '*';
                             end;
                        end;
                 end;

               Layout;

               GoToXY(8,9);
               write('User Information');

               GoToXY(12,12);
               write('Nick Name');

               GoToXY(12,14);
               write('Change Password');

               GoToXY(11,22);
               write('Press ''Space Bar'' to modify');
               end;
          72 : if opt > 1 then opt := opt - 1;
          80 : if opt < no_userinfo then opt := opt + 1;
             end;
     end;
End;

Procedure usersettings;
Var key_usersettings, i : integer;
    ch_disct, ch_logt : boolean;
Begin
     key := 0;
     key_usersettings := 0;
     ch_disct := true;
     ch_logt := false;

     Layout;

     textcolor(11);

     for i := 1 to 17 do
     begin
          GoToXY(41,6 + i);
          write(style);

          GoToXY(40 + 2 * i,18);
          write(' ',style);
     end;

     while (key <> 27) and (key_usersettings <> 8) do
     begin
          textcolor(11);

          if ch_disct then textbackground(12)
          else textbackground(16);

          for i := 1 to 17 do
          begin
               GoToXY(4,6 + i);
               write(' ':37);
          end;

          GoToXY(19,14);
          write('Discount');

          if (not ch_disct) and (not ch_logt) then textbackground(12)
          else textbackground(16);

          for i := 1 to 11 do
          begin
               GoToXY(42,6 + i);
               write(' ':35);
          end;

          GoToXY(53,11);
          write('User Information');

          if (not ch_disct) and (ch_logt) then textbackground(12)
          else textbackground(16);

          for i := 1 to 5 do
          begin
               GoToXY(42,18 + i);
               write(' ':35);
          end;

          GoToXY(58,21);
          write('Logout');

          GoToXY(80,25);

          key_usersettings := ord(readkey);
          key := key_usersettings;

          case key_usersettings of
          13 : begin
                    if ch_disct then discount;

                    if (not ch_disct) and (not ch_logt) then userinfo;

                    if (not ch_disct) and (ch_logt) then
                         if messagebox(0,'Logout ?','Reminder',MB_YesNo + MB_ApplModal + MB_DefButton2 + MB_IconQuestion) = IDYes then
                         begin
                              logn := true;
                              user_name := 'Welcome';
                              key := 27;
                              end;

                    textcolor(11);
                    textbackground(16);

                    for i := 1 to 17 do
                    begin
                         GoToXY(41,6 + i);
                         write(style);

                         GoToXY(40 + 2 * i,18);
                         write(' ',style);
                         end;
                    end;
          75 : ch_disct := true;
          77 : ch_disct := false;
          72 : if ch_disct = false then ch_logt := false;
          80 : if ch_disct = false then ch_logt := true;
             end;
     end;
End;

Procedure settings;                                                             {Settings}
Const no_settings = 5;
Var key_settings, opt, count_lang, count_style, count_wifi, count_gps, count_nfc, i : integer;
    ch_settings : array[1..no_settings] of string;
Begin
     key := 0;
     key_settings := 0;
     opt := 1;
     count_lang := 1;
     if style = '`' then count_style := 2 else count_style := 1;
     if on_wifi then count_wifi := 2 else count_wifi := 1;
     if on_gps then count_gps := 2 else count_gps := 1;
     if on_nfc then count_nfc := 2 else count_nfc := 1;

     ch_settings[1] := 'English';

     Layout;

     while (key <> 27) and (key_settings <> 8) do
     begin
          textcolor(14);
          textbackground(16);

          GoToXY(8,9);
          write('Settings');

          GoToXY(12,12);
          write('Language');

          GoToXY(12,14);
          write('Menu Style');

          GoToXY(12,16);
          write('Wi-Fi');

          GoToXY(12,18);
          write('GPS');

          GoToXY(12,20);
          write('NFC');

          GoToXY(11,23);
          write('Press ''Space Bar'' to modify');

          while (key <> 27) and (key_settings <> 8) do
          begin
               textcolor(11);

               if style = '`' then ch_settings[2] := 'Boundary' else ch_settings[2] := 'No Boundary';
               if on_wifi then ch_settings[3] := 'ON' else ch_settings[3] := 'OFF';
               if on_gps then ch_settings[4] := 'ON' else ch_settings[4] := 'OFF';
               if on_nfc then ch_settings[5] := 'ON' else ch_settings[5] := 'OFF';

               for i := 1 to no_settings do
               begin
                    textcolor(11);
                    textbackground(16);

                    if opt = i then textcolor(14)
                    else textcolor(16);

                    GoToXY(40,10 + 2 * i);
                    write('>','<':29);

                    if opt = i then textbackground(9)
                    else textbackground(16);

                    GoToXY(42,10 + 2 * i);
                    write(' ':26);

                    textcolor(11);

                    GoToXY(42 + (13 - length(ch_settings[i]) div 2),10 + 2 * i);
                    write(ch_settings[i]);
               end;

               GoToXY(80,25);

               key_settings := ord(readkey);
               key := key_settings;

               case key_settings of
               32 : begin
                         case opt of
                         1 : begin
                                  count_lang := count_lang + 1;

                                  if (count_lang mod 2) > 0 then ch_settings[1] := 'English'
                                  else ch_settings[1] := 'Chinese (Not Available)';
                                  end;
                         2 : begin
                                  draw_box := true;

                                  count_style := count_style + 1;

                                  if (count_style mod 2) > 0 then
                                  begin
                                       ch_settings[2] := 'No Boundary';
                                       style := ' ';
                                       end
                                  else begin
                                            ch_settings[2] := 'Boundary';
                                            style := '`';
                                            end;
                                  end;
                         3 : begin
                                  count_wifi := count_wifi + 1;

                                  if (count_wifi mod 2) > 0 then on_wifi := false
                                  else on_wifi := true;

                                  textColor(10);
                                  textbackground(13);

                                  GoToXY(30,3);
                                  if on_wifi then write('WiFi') else  write('    ');
                                  end;
                         4 : begin
                                  count_gps := count_gps + 1;

                                  if (count_gps mod 2) > 0 then on_gps := false
                                  else on_gps := true;

                                  textcolor(10);
                                  textbackground(13);

                                  GoToXY(38,3);
                                  if on_gps then write('GPS') else  write('   ');
                                  end;
                         5 : begin
                                  count_nfc := count_nfc + 1;

                                  if (count_nfc mod 2) > 0 then on_nfc := false
                                  else on_nfc := true;

                                  textcolor(10);
                                  textbackground(13);

                                  GoToXY(46,3);
                                  if on_nfc then write('NFC') else  write('   ');
                                  end;
                           end;
                         end;
               72 : if opt > 1 then opt := opt - 1;
               80 : if opt < no_settings then opt := opt + 1;
                  end;
          end;
     end;
End;

Procedure aboutus;
Var key_aboutus, opt, i : integer;
    ch_info : array[0..3] of string;
    opt_support : boolean;
Begin
     key := 0;
     key_aboutus := 0;
     opt := 0;
     opt_support := false;

     ch_info[0] := '    Overview     ';
     ch_info[1] := '    History      ';
     ch_info[2] := '    Facilities   ';
     ch_info[3] := '    Contact us   ';

     Layout;

     GoToXY(8,9);
     write('About Us');

     GoToXY(5,11);
     for i := 1 to 71 do write('_');

     GoToXY(4,12);
     write('|','|':18,'|':18,'|':18,'|':18);

     GoToXY(5,13);
     for i := 1 to 71 do write('_');

     while (key <> 27) and (key_aboutus <> 8) do
     begin
          for i := 0 to 3 do
          begin
               textbackground(16);

               if opt = i then textbackground(10);

               GoToXY(5 + 18 * i,12);
               write(ch_info[i]);
          end;

          textbackground(16);

          for i := 1 to 10 do
          begin
               GoToXY(4,13 + i);
               write(' ':73);
          end;

          case opt of
          0 : begin
                   GoToXY(10,16);
                   write('The Theme of the Park is Ocean.');

                   GoToXY(10,18);
                   write('We aim to arise people''s awareness on Ocean Protection.');
                   end;
          1 : begin
                   GoToXY(10,16);
                   write('The Park was started to be built in 1993 and was finished');

                   GoToXY(10,17);
                   write('on 24 March 1995');

                   GoToXY(10,19);
                   write('The Opening Ceremony was held on 1 May 1995');
                   end;
          2 : begin
                   GoToXY(10,16);
                   write('The Park can be divided into two areas :');

                   GoToXY(12,18);
                   write('1. Entertainment');

                   GoToXY(12,20);
                   write('2. Leisure');
                   end;
          3 : begin
                   GoToXY(10,16);
                   write('Telephone :  1234 5678');

                   GoToXY(10,18);
                   write('Fax no.   :  1234 5678');

                   GoToXY(10,20);
                   write('Address   :  xxxxxxxxxx');

                   GoToXY(50,16);
                   write('Online Support');

                   if opt_support then
                   begin
                        GoToXY(48,18);
                        write('[ Not Available ]');
                        end
                   else begin
                             GoToXY(40,18);
                             write('[ Press ''Enter'' for online support ]');
                             end;
                   end;
            end;

          GoToXY(80,25);

          key_aboutus := ord(readkey);
          key := key_aboutus;

          case key_aboutus of
          13 : if opt = 3 then
               begin
                    opt_support := true;

                    GoToXY(40,18);
                    write('                                     ');

                    GoToXY(48,18);
                    write('[ Not Available ]');
                    end;
          75 : if opt > 0 then opt := opt - 1;
          77 : if opt < 3 then opt := opt + 1;
             end;
     end;
End;

Procedure map_A(var key_ch_map : integer);                                      {Function : Map}
Type location = record
                  name : string;
                  ind_X, ind_Y : integer;
                  end;
Var key_map_A, count_position, pos_X, pos_Y, opt, i : integer;
    data_map : array[1..6] of location;
Begin
     key := 0;
     key_map_A := 0;
     key_ch_map := 0;
     count_position := 1;
     opt := 1;
     pos_X := random(30) + 42;
     pos_Y := random(9) + 12;

     reset(db_mapA);

     for i := 1 to 6 do
     with data_map[i] do
     begin
          readln(db_mapA, name);
          readln(db_mapA, ind_X, ind_Y);
     end;

     Layout;

     GoToXY(10,9);
     write('Zone A    ( Entertainment )');

     textcolor(8);

     GoToXY(46,9);
     write(' Zone B    ( Leisure )');

     textcolor(16);

     GoToXY(6,9);
     write('<');

     textcolor(10);

     GoToXY(74,9);
     write('>');

     textbackground(13);

     for i := 1 to 10 do
     begin
          GoToXY(7,11 + i);
          write(' ':34);
     end;

     textcolor(16);

     GoToXY(7,21);
     write('   My Position [ Press ''M'' ]',' ':6);

     while (key <> 27) and (key_map_A <> 8) and (key_ch_map <> 77) do
     begin
          for i := 1 to 6 do
          begin
               if opt = i then
               begin
                    textcolor(15);
                    textbackground(16);
                    end
               else begin
                         textcolor(16);
                         textbackground(13);
                         end;

               with data_map[i] do
               begin
                    GoToXY(7,12 + i);
                    write('   ',name,' ':(31 - length(name)));

                    if opt = i then textcolor(12)
                    else textcolor(14);
                    textbackground(16);

                    GoToXY(ind_X,ind_Y);
                    write('X');
               end;
          end;

          GoToXY(80,25);

          key_map_A := ord(readkey);
          key := key_map_A;
          key_ch_map := key_map_A;

          case key_map_A of
          32 : begin
                    if (on_gps) and ((count_position mod 2) = 0) then
                    begin
                         textcolor(13);

                         GoToXY(35,23);
                         write(random(20) + 10);
                         end;
                    end;
          72 : begin
                    if opt > 1 then opt := opt - 1;

                    GoToXY(35,23);
                    write('  ');
                    end;
          80 : begin
                    if opt < 6 then opt := opt + 1;

                    GoToXY(35,23);
                    write('  ');
                    end;
          109 : begin
                     count_position := count_position + 1;

                     if on_gps then
                     begin
                          if (count_position mod 2) > 0 then
                          begin
                               textcolor(16);
                               textbackground(16);

                               GoToXY(pos_X,pos_Y);
                               write(' ');

                               GoToXY(6,23);
                               write('                               ');
                               write('                                     ');
                               end
                          else begin
                                    textcolor(13);
                                    textbackground(16);

                                    GoToXY(pos_X,pos_Y);
                                    write('X');

                                    textcolor(14);

                                    GoToXY(6,23);
                                    write('   Estimated Arrival Time :    ');
                                    write('     [ Press ''Space Bar'' to check ]');
                                    end;

                          textbackground(13);

                          GoToXY(7,21);
                          write('   My Position [ Press ''M'' ]',' ':6);
                          end
                     else begin
                               textcolor(14);
                               textbackground(13);

                               GoToXY(7,21);
                               write('   Turn on GPS to activate    ');
                               end;
                end;
             end;
     end;

     close(db_mapA);
End;

Procedure map_B(var key_ch_map : integer);
Type location = record
                  name : string;
                  ind_X, ind_Y : integer;
                  end;
Var key_map_B, count_position, pos_X, pos_Y, opt, i : integer;
    data_map : array[1..7] of location;
Begin
     key := 0;
     key_map_B := 0;
     key_ch_map := 0;
     count_position := 1;
     opt := 1;
     pos_X := random(34) + 7;
     pos_Y := random(9) + 12;

     reset(db_mapB);

     for i := 1 to 7 do
     with data_map[i] do
     begin
          readln(db_mapB, name);
          readln(db_mapB, ind_X, ind_Y);
     end;

     Layout;

     GoToXY(46,9);
     write(' Zone B    ( Leisure )');

     textcolor(8);

     GoToXY(10,9);
     write('Zone A    ( Entertainment )');

     textcolor(10);

     GoToXY(6,9);
     write('<');

     textcolor(16);

     GoToXY(74,9);
     write('>');

     textbackground(13);

     for i := 1 to 10 do
     begin
          GoToXY(41,11 + i);
          write(' ':33);
     end;

     textcolor(16);

     GoToXY(41,21);
     write('   My Position [ Press ''M'' ]',' ':5);

     while (key <> 27) and (key_map_B <> 8) and (key_ch_map <> 75) do
     begin
          for i := 1 to 7 do
          begin
               if opt = i then
               begin
                    textcolor(15);
                    textbackground(16);
                    end
               else begin
                         textcolor(16);
                         textbackground(13);
                         end;

               with data_map[i] do
               begin
                    GoToXY(41,12 + i);
                    write('   ',name,' ':(30 - length(name)));

                    if opt = i then textcolor(12)
                    else textcolor(14);
                    textbackground(16);

                    GoToXY(ind_X,ind_Y);
                    write('X');
               end;
          end;

          GoToXY(80,25);

          key_map_B := ord(readkey);
          key := key_map_B;
          key_ch_map := key_map_B;

          case key_map_B of
          32 : begin
                    if (on_gps) and ((count_position mod 2) = 0) then
                    begin
                         textcolor(13);

                         GoToXY(35,23);
                         write(random(20) + 10);
                         end;
                    end;
          72 : begin
                    if opt > 1 then opt := opt - 1;

                    GoToXY(35,23);
                    write('  ');
                    end;
          80 : begin
                    if opt < 7 then opt := opt + 1;

                    GoToXY(35,23);
                    write('  ');
                    end;
          109 : begin
                     count_position := count_position + 1;

                     if on_gps then
                     begin
                          if (count_position mod 2) > 0 then
                          begin
                               textcolor(16);
                               textbackground(16);

                               GoToXY(pos_X,pos_Y);
                               write(' ');

                               GoToXY(6,23);
                               write('                               ');
                               write('                                     ');
                               end
                          else begin
                                    textcolor(13);
                                    textbackground(16);

                                    GoToXY(pos_X,pos_Y);
                                    write('X');

                                    textcolor(14);

                                    GoToXY(6,23);
                                    write('   Estimated Arrival Time :    ');
                                    write('     [ Press ''Space Bar'' to check ]');
                                    end;

                          textbackground(13);

                          GoToXY(41,21);
                          write('   My Position [ Press ''M'' ]',' ':5);
                          end
                     else begin
                               textcolor(14);
                               textbackground(13);

                               GoToXY(41,21);
                               write('   Turn on GPS to activate    ');
                               end;
                end;
             end;

     end;

     close(db_mapB);
End;

Procedure map;
Var key_map, key_ch_map : integer;
    ch_left : boolean;
Begin
     key := 0;
     key_map := 0;
     key_ch_map := 0;
     ch_left := true;

     Layout;

     GoToXY(8,9);
     write('Map');

     while (key <> 27) and (key_map <> 8) do
     begin
          textcolor(11);

          if ch_left then textbackground(13)
          else textbackground(16);

          for i := 1 to 10 do
          begin
               GoToXY(7,11 + i);
               write(' ':34);
          end;

          GoToXY(21,15);
          write('Zone A');

          GoToXY(18,17);
          write('Entertainment');

          if ch_left then textbackground(16)
          else textbackground(13);

          for i := 1 to 10 do
          begin
               GoToXY(41,11 + i);
               write(' ':33);
          end;

          GoToXY(55,15);
          write('Zone B');

          GoToXY(55,17);
          write('Leisure');

          GoToXY(80,25);

          key_map := ord(readkey);
          key := key_map;

          case key_map of
          13 : begin
                    if ch_left then map_A(key_ch_map)
                    else map_B(key_ch_map);

                    while (key_ch_map <> 8) and (key_ch_map <> 27) do
                    begin
                         case key_ch_map of
                         75 : map_A(key_ch_map);
                         77 : map_B(key_ch_map);
                            end;
                         end;

                    key_map := key_ch_map;
                    key := key_ch_map;
                    end;
          75 : ch_left := true;
          77 : ch_left := false;
             end;
     end;
End;

Procedure facilities;
Const no_facils = 6;
Var key_facilities, opt, upper, lower, i : integer;
    search : string;
    temp : array[1..7] of string;
    facils : array[1..no_facils] of string;
    result : boolean;
Begin
     key := 0;
     key_facilities := 0;
     opt := 1;
     upper := 1;
     lower := 4;

     reset(db_facils);

     for i := 1 to no_facils do readln(db_facils, facils[i]);

     Layout;

     GoToXY(8,9);
     write('Facilities');

     GoToXY(7,23);
     write('[ Press ''Space Bar'' to obtain the Fass pass ]');

     GoToXY(54,12);
     write('Events Search');

     GoToXY(47,14);
     write('[ Press ''Enter'' to Search ]');

     textbackground(13);

     for i := 1 to 10 do
     begin
          GoToXY(6,11 + i);
          write(' ':35);
     end;

     while (key <> 27) and (key_facilities <> 8) do
     begin
          textBackground(13);

          if opt = 1 then textcolor(8)
             else textcolor(10);
          GoToXY(23,12);
          write('/\');

          if opt = no_facils then textcolor(8)
             else textcolor(10);
          GoToXY(23,21);
          write('\/');

          for i := upper to lower do
          begin
               if opt = i then
               begin
                    textcolor(15);
                    textbackground(16);
                    end
               else begin
                         textcolor(16);
                         textbackground(13);
                         end;

               GoToXY(6,11 + 2 * (i - lower + 4));
               write('   ',facils[i],' ':(32 - length(facils[i])));

               textcolor(11);
               textbackground(13);

               if fac_ftps[i] = '[ Obtained ] ' then textcolor(14);

               GoToXY(12,12 + 2 * (i - lower + 4));
               write('   ',fac_ftps[i]);
          end;

          GoToXY(80,25);

          key_facilities := ord(readkey);
          key := key_facilities;

          case key_facilities of
          13 : begin
                    textcolor(15);
                    textbackground(16);

                    GoToXY(47,14);
                    write('                             ');

                    GoToXY(47,16);
                    write('                             ');

                    GoToXY(47,18);
                    write('                       ');

                    GoToXY(47,14);
                    readln(search);

                    reset(db_event);

                    for i := 1 to 7 do
                    begin
                         readln(db_event);
                         readln(db_event,temp[i]);
                         readln(db_event);
                         readln(db_event);
                         readln(db_event);
                         end;

                    result := false;

                    textcolor(14);

                    for i := 1 to 7 do
                        if not result then
                           if search = temp[i] then
                           begin
                                result := true;

                                GoToXY(47,16);
                                write(search);

                                randomize;

                                GoToXY(47,18);
                                write('Remaining Seat : ',(random(100) + 50),' ':9);
                                end;

                    if not result then
                    begin
                         GoToXY(47,18);
                         write('   [ No result found ]',' ':8);
                         end;
                    end;
          32 : begin
                    if fac_ftps[opt] = '[ Available ]' then
                    begin
                         if messagebox(0,'Confirm ?','Reminder',MB_YesNo + MB_ApplModal + MB_DefButton2 + MB_IconQuestion) = IDYes then
                         begin
                              fac_ftps[opt] := '[ Obtained ] ';

                              messagebox(0,'Successfully obtained','Reminder',MB_OK + MB_ApplModal + MB_IconInformation);
                              end;
                         end
                    else messagebox(0,'You have obtained the fass pass already','Warning',MB_OK + MB_ApplModal + MB_IconWarning);
                    end;
          72 : begin
                    if opt > 1 then opt := opt - 1;
                    if opt < upper then upper := opt;
                    if (lower - upper) > 3 then lower := lower - 1;
                    end;
          80 : begin
                    if opt < no_facils then opt := opt + 1;
                    if opt > lower then lower := opt;
                    if (lower - upper) > 3 then upper := upper + 1;
                    end;
             end;
     end;
End;

Procedure restaurants;
Type res = record
                 name, typ, des : string;
                 end;
Const no_restnt = 5;
Var key_restaurants, opt, upper, lower, i : integer;
    data_res : array[1..no_restnt] of res;
Begin
     key := 0;
     key_restaurants := 0;
     opt := 1;
     upper := 1;
     lower := 4;

     reset(db_restnt);

     for i := 1 to no_restnt do
         with data_res[i] do
         begin
              readln(db_restnt, name);
              readln(db_restnt, typ);
              readln(db_restnt, des);
              end;

     Layout;

     GoToXY(8,9);
     write('Restaurants');

     GoToXY(7,23);
     if on_wifi then write('[ Press ''Space Bar'' to book the Restaurant ]')
     else write('Booking is available with a Wi-Fi connection');

     textbackground(13);

     for i := 1 to 10 do
     begin
          GoToXY(6,11 + i);
          write(' ':35);
     end;

     while (key <> 27) and (key_restaurants <> 8) do
     begin
          textBackground(13);

          if opt = 1 then textcolor(8)
             else textcolor(10);
          GoToXY(23,12);
          write('/\');

          if opt = no_restnt then textcolor(8)
             else textcolor(10);
          GoToXY(23,21);
          write('\/');

          for i := upper to lower do
          begin
               with data_res[i] do
               begin
                    if opt = i then
                    begin
                         textcolor(15);
                         textbackground(16);
                         end
                    else begin
                              textcolor(16);
                              textbackground(13);
                              end;

                    GoToXY(6,11 + 2 * (i - lower + 4));
                    write('   ',name,' ':(32 - length(name)));

                    textcolor(11);
                    textbackground(13);

                    if res_book[i] = '[ Booked ]   ' then textcolor(14);

                    GoToXY(12,12 + 2 * (i - lower + 4));
                    write('   ',res_book[i]);
                    end;
          end;

          textcolor(14);
          textbackground(16);

          with data_res[opt] do
          begin
               GoToXY(45,14);
               write(typ,' ':(32 - length(typ)));

               GoToXY(47,16);
               write(des,' ':(30 - length(des)));
          end;

          GoToXY(80,25);

          key_restaurants := ord(readkey);
          key := key_restaurants;

          case key_restaurants of
          32 : if on_wifi then
               begin
                    if res_book[opt] = '[ Available ]' then
                    begin
                         if messagebox(0,'Confirm ?','Reminder',MB_YesNo + MB_ApplModal + MB_DefButton2 + MB_IconQuestion) = IDYes then
                         begin
                              res_book[opt] := '[ Booked ]   ';

                              messagebox(0,'Successfully booked','Reminder',MB_OK + MB_ApplModal + MB_IconInformation);
                              end;
                         end
                    else messagebox(0,'You have booked the restaurant already','Warning',MB_OK + MB_ApplModal + MB_IconWarning);
                    end;
          72 : begin
                    if opt > 1 then opt := opt - 1;
                    if opt < upper then upper := opt;
                    if (lower - upper) > 3 then lower := lower - 1;
                    end;
          80 : begin
                    if opt < no_restnt then opt := opt + 1;
                    if opt > lower then lower := opt;
                    if (lower - upper) > 3 then upper := upper + 1;
                    end;
             end;
     end;
End;

Procedure events;                                                               {Function : Events}
Type event = record
               time, name, location, des_1, des_2 : string;
               end;
Const no_event = 7;
Var key_events, opt, i : integer;
    upper : 1..(no_event - 3);
    lower : 4..no_event;
    rept : boolean;
    ch_event : array[1..no_event] of event;
Begin
     key := 0;
     key_events := 0;
     opt := 1;
     upper := 1;
     lower := 4;
     rept := false;

     reset(db_event);

     for i := 1 to no_event do
         with ch_event[i] do
         begin
              readln(db_event, time);
              readln(db_event, name);
              readln(db_event, location);
              readln(db_event, des_1);
              readln(db_event, des_2);
              end;

     Layout;

     GoToXY(8,9);
     write('Today''s Events');

     GoToXY(7,23);
     write('[ Press ''Space Bar'' to record the event ]');

     textbackground(13);

     for i := 1 to 10 do
     begin
          GoToXY(6,11 + i);
          write(' ':35);
     end;

     while (key <> 27) and (key_events <> 8) do
     begin
          textBackground(13);

          if opt = 1 then textcolor(8)
             else textcolor(10);
          GoToXY(23,12);
          write('/\');

          if opt = no_event then textcolor(8)
             else textcolor(10);
          GoToXY(23,21);
          write('\/');

          for i := upper to lower do
              with ch_event[i] do
              begin
                   if i = opt then
                   begin
                        textcolor(15);
                        textbackground(16);
                        end
                   else begin
                             textcolor(16);
                             textbackground(13);
                             end;

                   if schelu_event[i] then textcolor(14);

                   GoToXY(6, 9 + 2 * (i + 5 - lower));
                   write(' ',time,'  ',name,' ':(27 - length(name)));

                   textcolor(11);
                   textbackground(13);
                   GoToXY(6, 10 + 2 * (i + 5 - lower));
                   write('        [ ',location,' ]',' ':(23 - length(location)));
                   end;

          with ch_event[opt] do
          begin
               textcolor(14);
               textbackground(16);

               GoToXY(42,12);
               write('  Time  :  ',time,' ':(24 - length(time)));

               GoToXY(42,13);
               write('  Venue :  ',location,' ':(24 - length(location)));

               GoToXY(42,15);
               write('  Event :  ',name,' ':(24 - length(name)));

               GoToXY(42,18);
               write('  Description :');

               GoToXY(42,20);
               write(' * ',des_1,' ':(32 - length(des_1)));

               GoToXY(42,21);
               write(' * ',des_2,' ':(32 - length(des_2)));
          end;

          GoToXY(80,25);

          key_events := ord(readkey);
          key := key_events;

          case key_events of
          32 : begin
                    no_schelu := no_schelu + 1;
                    data_schelu[no_schelu] := ch_event[opt].time + '  ' + ch_event[opt].name;
                    schelu_event[opt] := true;
                    rept := false;

                    for i := 1 to (no_schelu - 1) do
                        if data_schelu[i] = data_schelu[no_schelu] then rept := true;

                    if rept then
                    begin
                         data_schelu[no_schelu] := '';
                         no_schelu := no_schelu - 1;
                         messagebox(0,'You have recorded the event already','Warning',MB_OK + MB_ApplModal + MB_IconWarning);
                         end;
                    end;
          72 : begin
                    if opt > 1 then opt := opt - 1;
                    if opt < upper then upper := upper - 1;
                    if (lower - upper) > 3 then lower := lower - 1;
                    end;
          80 : begin
                    if opt < no_event then opt := opt + 1;
                    if opt > lower then lower := lower + 1;
                    if (lower - upper) > 3 then upper := upper + 1;
                    end;
            end;
     end;

     close(db_event);
End;

Procedure schedule;
Var key_schedule, upper, lower, i, j : integer;
    temp : string;
Begin
     key := 0;
     key_schedule := 0;
     upper := 1;
     lower := 8;

     for i := no_schelu downto 1 do
         for j := 1 to (i - 1) do
             if data_schelu[j] > data_schelu[j + 1] then
             begin
                  temp := data_schelu[j];
                  data_schelu[j] := data_schelu[j + 1];
                  data_schelu[j + 1] := temp;
             end;

     rewrite(db_schelu);

     for i := 1 to no_schelu do writeln(db_schelu,data_schelu[i]);

     Layout;

     GoToXY(8,9);
     write('Own Schedule');

     GoToXY(7,23);
     write('[ Press ''Delete'' to Reset the Schedule ]');

     textbackground(13);

     for i := 1 to 10 do
     begin
          GoToXY(6,11 + i);
          write(' ':35);
     end;

     while (key <> 27) and (key_schedule <> 8) do
     begin
          textBackground(13);

          if upper = 1 then textcolor(8)
             else textcolor(10);
          GoToXY(23,12);
          write('/\');

          if (lower = no_schelu) or (no_schelu < 9) then textcolor(8)
             else textcolor(10);
          GoToXY(23,21);
          write('\/');

          textcolor(14);

          for i := upper to lower do
          begin
               GoToXY(6, 11 + i + 9 - lower);
               write(' ',data_schelu[i],' ':(34 - length(data_schelu[i])));
          end;

          GoToXY(80,25);

          key_schedule := ord(readkey);
          key := key_schedule;

          case key_schedule of
          83 : begin
                    rewrite(db_schelu);

                    for i := 1 to no_schelu do
                    begin
                         data_schelu[i] := '';
                         schelu_event[i] := false;
                         end;

                    no_schelu := 0;
                    end;
          72 : begin
                    if upper > 1 then upper := upper - 1;
                    if (lower - upper) > 7 then lower := lower - 1;
                    end;
          80 : begin
                    if lower < no_schelu then lower := lower + 1;
                    if (lower - upper) > 7 then upper := upper + 1;
                    end;
             end;
     end;

     close(db_schelu);
End;

Procedure functions;
Var key_functions, opt, i : integer;
    ch_func : array[1..5] of string;
Begin
     key := 0;
     key_functions := 0;
     opt := 1;

     ch_func[1] := 'Map';
     ch_func[2] := 'Facilities';
     ch_func[3] := 'Restaurants';
     ch_func[4] := 'Today''s Events';
     ch_func[5] := 'Own Schedule';

     Layout;

     GoToXY(8,9);
     write('Functions');

     while (key <> 27) and (key_functions <> 8) do
     begin
          textbackground(16);

          for i := 1 to 5 do
          begin
               textcolor(11);

               if opt = i then textbackground(9)
               else textbackground(16);

               GoToXY(22,10 + 2 * i);
               writeln('        ',ch_func[i],' ':26 - length(ch_func[i]));

               if opt = i then textcolor(14)
               else textcolor(16);

               textbackground(16);

               GoToXY(17,10 + 2 * i);
               write('>');

               GoToXY(60,10 + 2 * i);
               write('<');
          end;

          GoToXY(80,25);

          key_functions := ord(readkey);
          key := key_functions;

          case key_functions of
          13 : begin
                    case opt of
                    1 : map;
                    2 : facilities;
                    3 : restaurants;
                    4 : events;
                    5 : schedule;
                      end;

                    Layout;

                    GoToXY(8,9);
                    write('Functions');
                    end;
          72 : if opt > 1 then opt := opt - 1;
          80 : if opt < 5 then opt := opt + 1;
             end;
     end;
End;

{Exit}                                                                          {Exit}
Procedure sysExit;
Begin
     close(readme);
     close(db_schelu);

     TextBackground(16);

     clrscr;

     TextColor(14);
     TextBackground(13);

     for i := 1 to 15 do
     begin
          GoToXY(10,5 + i);
          write(' ':60);
     end;

     GoToXY(27,12);
     writeln('Thankyou for using the System');

     GoToXY(80,25);

     Delay(1600);
End;

{Main Program}                                                                  {Main Program}
Begin
     {Initialize}
     key := 0;
     key_menu := 0;
     ch_menuX := 1;
     ch_menuY := 1;
     pre_menuX := 1;
     pre_menuY := 1;
     draw_box := true;
     draw_menu := true;

     style := ' ';

     assign(readme, db_loc + 'readme.txt');
     reset(readme);
     readln(readme, ok_readme);

     assign(db_disct, db_loc + 'database\database_discount.txt');
     assign(db_mapA, db_loc + 'database\database_map_A.txt');
     assign(db_mapB, db_loc + 'database\database_map_B.txt');
     assign(db_facils, db_loc + 'database\database_facilities.txt');
     assign(db_event, db_loc + 'database\database_event.txt');
     assign(db_restnt, db_loc + 'database\database_restaurant.txt');
     assign(db_schelu, db_loc + 'database\database_schedule.txt');
     rewrite(db_schelu);

     logn := true;
     user_name := 'Welcome';
     on_wifi := false;
     on_gps := false;
     on_nfc := false;

     remind_disct := false;
     no_disQuo := 3;
     no_schelu := 0;

     for i := 1 to 6 do no_disct[i] := 0;

     for i := 1 to 14 do fac_ftps[i] := '[ Available ]';

     for i := 1 to 14 do res_book[i] := '[ Available ]';

     for i := 1 to 20 do schelu_event[i] := false;

     TextColor(14);
     TextBackground(13);

     for i := 1 to 15 do
     begin
          GoToXY(10,5 + i);
          write(' ':60);
     end;

     GoToXY(32,10);
     write('Theme Park System');

     GoToXY(30,14);
     write('Welcome to the System');

     GoToXY(80,25);

     delay(1600);

     if ok_readme <> 'true' then
     begin
          TextBackground(16);

          clrscr;

          TextBackground(13);

          for i := 1 to 15 do
          begin
               GoToXY(10,5 + i);
               write(' ':60);
          end;

          GoToXY(24,10);
          write('Please read the ''readme.txt'' file');

          GoToXY(28,12);
          write('before using the system');

          GoToXY(80,25);

          delay(3000);
          end
     else begin
     while key_menu <> 8 do
     begin
          {draw layout if necessary}
          if draw_menu then
          begin
               Layout;

               textcolor(11);

               for i := 1 to 17 do
               begin
                    GoToXY(41,6 + i);
                    write(style);
                    end;

               GoToXY(2,16);
               for i := 1 to 19 do write(' ',style);

               GoToXY(42,12);
               for i := 1 to 18 do write(' ',style);

               GoToXY(24,11);
               if logn then write('User Login')
               else write('User Settings');

               GoToXY(25,20);
               write('Settings');

               GoToXY(63,9);
               write('About Us');

               GoToXY(62,19);
               write('Functions');

               draw_menu := false;
          end;

          textcolor(11);

          {menuLayout_login}
          if (pre_menuX = 1) and (pre_menuY = 1) then textbackground(16);
          if (ch_menuX = 1) and (ch_menuY = 1) then textbackground(12);

          if ((ch_menuX = 1) and (ch_menuY = 1)) or ((pre_menuX = 1) and (pre_menuY = 1)) then
          begin
               for i := 1 to 9 do
               begin
                    GoToXY(4,6 + i);
                    write(' ':37);
                    end;

               GoToXY(24,11);
               if logn then write('User Login')
               else write('User Settings');
          end;

          {menuLayout_settings}
          if (pre_menuX = 1) and (pre_menuY = 2) then textbackground(16);
          if (ch_menuX = 1) and (ch_menuY = 2) then textbackground(9);

          if ((ch_menuX = 1) and (ch_menuY = 2)) or ((pre_menuX = 1) and (pre_menuY = 2)) then
          begin
               for i := 1 to 7 do
               begin
                    GoToXY(4,16 + i);
                    write(' ':37);
                    end;

               GoToXY(25,20);
               write('Settings');
          end;

          {menuLayout_aboutus}
          if (pre_menuX = 2) and (pre_menuY = 1) then textbackground(16);
          if (ch_menuX = 2) and (ch_menuY = 1) then textbackground(10);

          if ((ch_menuX = 2) and (ch_menuY = 1)) or ((pre_menuX = 2) and (pre_menuY = 1)) then
          begin
               for i := 1 to 5 do
               begin
                    GoToXY(42,6 + i);
                    write(' ':35);
                    end;

               GoToXY(63,9);
               write('About Us');
          end;

          {menuLayout_functions}
          if (pre_menuX = 2) and (pre_menuY = 2) then textbackground(16);
          if (ch_menuX = 2) and (ch_menuY = 2) then textbackground(13);

          if ((ch_menuX = 2) and (ch_menuY = 2)) or ((pre_menuX = 2) and (pre_menuY = 2)) then
          begin
               for i := 1 to 11 do
               begin
                    GoToXY(42,12 + i);
                    write(' ':35);
                    end;

               GoToXY(62,19);
               write('Functions');
          end;

          GoToXY(80,25);

          if remind_disct then
          messagebox(0,'Your user discount can be obtained in ''User Settings''','Reminder',MB_OK + MB_ApplModal + MB_IconInformation);

          remind_disct := false;

          key_menu := ord(readkey);

          case key_menu of
          13 : begin
                    if ch_menuX = 1 then
                         if ch_menuY = 1 then
                              if logn then login
                              else usersettings
                         else settings
                    else if ch_menuY = 1 then aboutus
                         else functions;

                    draw_box := true;
                    draw_menu := true;
                    end;
          72 : begin
                    pre_menuX := ch_menuX;
                    pre_menuY := ch_menuY;
                    ch_menuY := 1;
                    end;
          80 : begin
                    pre_menuX := ch_menuX;
                    pre_menuY := ch_menuY;
                    ch_menuY := 2;
                    end;
          75 : begin
                    pre_menuX := ch_menuX;
                    pre_menuY := ch_menuY;
                    ch_menuX := 1;
                    end;
          77 : begin
                    pre_menuX := ch_menuX;
                    pre_menuY := ch_menuY;
                    ch_menuX := 2;
                    end;
          8 : sysExit;
            end;
     end;
     end;
End.
