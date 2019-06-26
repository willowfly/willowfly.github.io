! 本程序读取 abaqus 的文件
! 2015-07-27 by RenLiujie 
! 2018-08-22 需要读取logfile来进行读取文件夹
! 2018-08-23 添加了surface的读取来进行读取文件夹
! 2018-09-17 添加了读取 c3d6 单元的功能
! 2018-09-18 添加了读取 c3d4 单元的功能
! 2019-04-08 增加了补0的操作
! 2019-05-05 增加了ELSET的读取
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

! 读取 log 文件, 获得当前工作目录
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
! 读取 abaqus3D inp 文件
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
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:16).eq.'S3') ) then ! 三角形单元
            mode = 'ELS3'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:16).eq.'S4') ) then ! 四边形单元
            mode = 'ELS4'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:18).eq.'C3D8') ) then ! 六面体单元
            mode = 'ELD8'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:18).eq.'C3D6') ) then ! 六面体单元
            mode = 'ELD6'
            etype = etype + 1
            write(*,*) trim(cmdline)
            close(unit = 12)
            write(charetype,'(i3.3)') etype
            write(inputfile,*) './',trim(folder),'/model_ele_',charetype,'.ele'
            write(*,*) trim(inputfile)
            open(unit = 12, file = inputfile(2:), status = 'replace', action = 'write')
        endif
        if( (cmdline(2:5).eq.'ELEM') .and. (cmdline(15:18).eq.'C3D4') ) then ! 四面体单元
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