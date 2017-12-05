FOLDCASE=: 0 
NB. set this to 1 if you have issues caused by the file system ignoring upper/lowercase 

normalizepaths=:3 :0 
  tolower^:FOLDCASE@rplc&'\/'L:0 y 
) 

extractdirs=:3 :0 L:0 
  (('/',y)i:'/'){.y 
) 

etags=:3 :0 
  paths=. normalizepaths boxopen y 
  dirs=. extractdirs paths 
  delims=. FF,LF 
  for_dir.~.dirs do. 
    TAGS=. (fread (;dir),'TAGS')-._1 
    assert. delims-:2{.TAGS,delims 
    Tfiles=. (0{::<;._2@,&',')L:0 (0{<;._1);._1 TAGS 
    files=. (dir=dirs)#paths 
    fnames=. (}.~ #@extractdirs)&.> files 
    keep=. -.Tfiles e. fnames 
    (;(keep#<;.1 TAGS),fnames etagsBlock&.> files) fwrite (;dir),'TAGS' 
  end. 
) 

etagsBlock=:4 :0 
  content=. (fread y)-._1 
  if. 0=#content do.'' return.end. 
  lns=. I.content=LF 
  NB. in this draft assume all instances of =: are valid and relevant definitions 
  dfns=. I. '=:' E. content 
  lnums=. <:lns I. dfns 
  pfxs=. content (<@:{~ (+i.)~/)"1 -/\."1 (2+dfns),.1+lnums{lns 
  detail=. ;LF,&.>~pfxs,&.>DEL,&.>lnums(,','&,)&":&.>lnums{lns 
  FF,LF,x,',',(":#detail),LF,detail 
) 
