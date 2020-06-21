ATSCC=$(PATSHOME)/bin/patscc
ATSOPT=$(PATSHOME)/bin/patsopt

ATSFLAGS=-IATS node_modules -IATS ../node_modules
CFLAGS=-DATS_MEMALLOC_LIBC -D_DEFAULT_SOURCE -I $(PATSHOME)/ccomp/runtime -I $(PATSHOME) -O3

LIBS=-L $(PATSHOME)/ccomp/atslib/lib -latslib

APP     = libats-unit-testing.a
ifndef STATICLIB
	CFLAGS+=-fpic
	LIBS+=-shared
	APP     = libats-unit-testing.so
endif

EXEDIR  = target
ifdef OUTDIR
	EXEDIR = $(OUTDIR)
endif
SRCDIR  = src
OBJDIR  = .build
vpath %.dats src
vpath %.dats src/DATS
vpath %.sats src/SATS
dir_guard=@mkdir -p $(@D)
SRCS    := $(shell find $(SRCDIR) -name '*.dats' -type f -exec basename {} \;)
OBJS    := $(patsubst %.dats,$(OBJDIR)/%.o,$(SRCS))

.PHONY: clean setup

all: $(EXEDIR)/$(APP)

$(EXEDIR)/$(APP): $(OBJS)
	$(dir_guard)
	ar rcs $@ $(OBJS)

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
	+make -C tests clean

test:
	+make -C tests
	+make -C tests run