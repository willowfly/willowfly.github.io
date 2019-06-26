! �������ȡ abaqus ���ļ�
! 2015-07-27 by RenLiujie 
! 2018-08-22 ��Ҫ��ȡlogfile�����ж�ȡ�ļ���
! 2018-08-23 �����surface�Ķ�ȡ�����ж�ȡ�ļ���
! 2018-09-17 ����˶�ȡ c3d6 ��Ԫ�Ĺ���
! 2018-09-18 ����˶�ȡ c3d4 ��Ԫ�Ĺ���
! 2019-04-08 �����˲�0�Ĳ���
! 2019-05-05 ������ELSET�Ķ�ȡ
program ReadAbaqus3D
implicit none

character(len=120)  :: logfile, folder, inputfile
character(len=180)  :: cmdline
character(len=4)    :: mode
integer             :: endoffile

integer             :: nod, ele, etype, bc, surf
integer             :: n1, n2, n3, n4, n5, n6, n7, n8, itmp, itmp2, i
integer             :: intarray(8)
real*8              :: x1, x2, x3
character(len=3)    :: charetype, charbc, charsurf

! ��ȡ log �ļ�, ��õ�ǰ����Ŀ¼
logfile = '__dic.log'
open(unit = 11, file = trim(logfile), status = 'old', action = 'read')
read(11,*) folder
close(unit=11)
n1 = system('cls')
write(*,*) '----------------- ABAQUS READER -----------------'
write(*,*) '| Working dictory >>> ', trim(folder)
write(*,*) '| Input file name >>> ', trim(folder),'.inp'
write(*,*) '-------------------------------------------------'
n1 = system('mkdir '//trim(folder));
write(*,*) '| Creating folder >>> ', trim(folder)
! ��ȡ abaqus3D inp �ļ�
open(unit = 11, file = './'//trim(folder)//'.inp', status = 'old', action = 'read')
endoffile = 0
etype = 0
nod = 0
ele = 0
bc = 0
surf = 0
do while(.true.)
    read(11,'(A180)',iostat = endoffile) cmdline
    if(endoffile.ne.0) exit
    if( cmdline(1:1).eq.'*' ) then
        mode = 'none'
        if(cmdline(2:5).eq.'NODE') then
            mode = 'NODE'
            write(*,*) cmdline
            close(unit = 12)
            write(inputfile,*) './',trim(folder),'/model_node.cnn'
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:16).eq.'S3') ) then ! �����ε�Ԫ
            mode = 'ELS3'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:16).eq.'S4') ) then ! �ı��ε�Ԫ
            mode = 'ELS4'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:18).eq.'C3D8') ) then ! �����嵥Ԫ
            mode = 'ELD8'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:18).eq.'C3D6') ) then ! �����嵥Ԫ
            mode = 'ELD6'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:18).eq.'C3D4') ) then ! �����嵥Ԫ
            mode = 'ELD4'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( cmdline(2:5).eq.'NSET') then
            mode = 'NSET'
            bc = bc + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charbc,'(i3.3)') bc
            write(inputfile,*) './',trim(folder),'/model_bc_',charbc,'.nset'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( cmdline(2:5).eq.'ELSE') then
            mode = 'ELSE'
            bc = bc + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charbc,'(i3.3)') bc
            write(inputfile,*) './',trim(folder),'/model_bc_',charbc,'.elset'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( cmdline(2:5).eq.'SURF') then
            mode = 'SURF'
            surf = surf + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charsurf,'(i3.3)') surf
            write(inputfile,*) './',trim(folder),'/model_surf_',charsurf,'.surf'
            write(*,*) inputfile
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
    else
        if(mode.eq.'NODE') then
            nod = nod + 1
            read(cmdline,*) itmp, x1, x2, x3
            ! write(12,*) nod, x1, x2
            write(12,*) itmp,',',x1,',',x2,',',x3
        endif
        if(mode.eq.'ELS3') then
            ele = ele + 1
            read(cmdline,*) itmp, n1, n2, n3
            ! write(12,*) ele, n1, n2, n3
            write(12,*) itmp,',',n1,',',n2,',',n3
        endif
        if(mode.eq.'ELS4') then
            ele = ele + 1
            read(cmdline,*) itmp, n1, n2, n3, n4
            ! write(12,*) ele, n1, n2, n3
            write(12,*) itmp,',',n1,',',n2,',',n3,',',n4
        endif
        if(mode.eq.'ELD8') then
            ele = ele + 1
            read(cmdline,*) itmp, n1, n2, n3, n4, n5, n6, n7
            read(11,'(A120)',iostat = endoffile) cmdline
            read(cmdline,*) n8
            ! write(12,*) ele, n1, n2, n3
            write(12,*) itmp,',',n1,',',n2,',',n3,',',n4,',',n5,',',n6,',',n7,',',n8
        endif
        if(mode.eq.'ELD6') then
            ele = ele + 1
            read(cmdline,*) itmp, n1, n2, n3, n4, n5, n6
            ! write(12,*) ele, n1, n2, n3
            write(12,*) itmp,',',n1,',',n2,',',n3,',',n4,',',n5,',',n6
        endif
        if(mode.eq.'ELD4') then
            ele = ele + 1
            read(cmdline,*) itmp, n1, n2, n3, n4
            ! write(12,*) ele, n1, n2, n3
            write(12,*) itmp,',',n1,',',n2,',',n3,',',n4
        endif
        if(mode.eq.'NSET') then
            do itmp = 8,1,-1
                read(cmdline,*,iostat = itmp2) intarray(1:itmp)
                if(itmp2.eq.0) then 
                    do i=1,itmp; write(12,*) intarray(i); enddo
                    exit
                endif
            enddo
        endif
        if(mode.eq.'ELSE') then
            write(12,*) trim(cmdline)
        endif
        if(mode.eq.'SURF') then
            write(12,*) trim(cmdline)
        endif
    endif
enddo

close(unit = 11); close(unit = 12); close(unit = 13)
endprogram ReadAbaqus3D