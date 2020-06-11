ATSCC=$(PATSHOME)/bin/patscc
ATSOPT=$(PATSHOME)/bin/patsopt

ATSFLAGS=-IATS node_modules -IATS ../node_modules
CFLAGS=-DATS_MEMALLOC_LIBC -D_DEFAULT_SOURCE -I . -I $(PATSHOME)/ccomp/runtime -I $(PATSHOME) -O3 -g

LIBS=-latslib -L ../target 

APP     = tests
EXEDIR  = target
SRCDIR  = .
OBJDIR  = .build
vpath %.dats .
dir_guard=@mkdir -p $(@D)
SRCS    := tests.dats
OBJS    := $(patsubst %.dats,$(OBJDIR)/%.o,$(SRCS))

.PHONY: clean setup

all: $(EXEDIR)/$(APP)

$(EXEDIR)/$(APP): $(OBJS)
	$(dir_guard)
	+make -C ..
	$(CC) $(CFLAGS) -o $(EXEDIR)/$(APP) $(OBJS) $(LIBS)

.SECONDEXPANSION:
$(OBJDIR)/%.o: %.c
	$(dir_guard)
	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/$(@F) 

$(OBJDIR)/%.c: %.dats
	$(dir_guard)
	$(ATSOPT) $(ATSFLAGS) -o $(OBJDIR)/$(@F) -d $<

RMF=rm -f

clean: 
	$(RMF) $(EXEDIR)/$(APP)
	$(RMF) $(OBJS)
	+make -C .. clean

run:
	./target/tests