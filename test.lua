local ffi = require( "ffi" )
local bor, band = bit.bor, bit.band

ffi.cdef
[[
    void    bcm_host_init();
    void    bcm_host_deinit();
    int32_t graphics_get_display_size( const uint16_t display_number,
				       uint32_t *width, uint32_t *height);
 ]]

ffi.cdef
[[
    enum 
    {
       O_RDONLY   = 0,
       O_NONBLOCK = 0x800,
    };
    int     open( const char* filename, int flags );
    int     read( int fd, void* buf, int count );
    typedef struct dev_input_mouse {
       char buttons, dx, dy;
    } dev_input_mouse;
]]

--print(ffi.C.open)	 

local lib = ffi.load("bcm_host")
if ... then
   return lib
end

print('testing')
print(lib)
lib.bcm_host_init()
print('test2')
local w = ffi.new("uint32_t[1]")
local h = ffi.new("uint32_t[1]")
for i=0, 1 do
   print(i, lib.graphics_get_display_size(i, w, h), w[0], h[0])
end

ffi.errno(0)
print('errno', ffi.errno())
local mfile = ffi.C.open( "/dev/input/mouse0", ffi.C.O_RDONLY + ffi.C.O_NONBLOCK);
print('mfile',mfile, 'errno', ffi.errno())
local mbuf = ffi.new( "dev_input_mouse[1]" );
local mfile = ffi.C.open( "/dev/input/mouse0", ffi.C.O_RDONLY + ffi.C.O_NONBLOCK);
print('mfile',mfile, 'errno', ffi.errno())

while true do
   while ffi.C.read(mfile, mbuf, ffi.sizeof(mbuf)) == ffi.sizeof(mbuf) and
      not band(mbuf[0]o.buttons, 8) do end
print('errno', ffi.errno(), 'bytes', bytes, 'mbuf', mbuf[0].buttons, mbuf[0].dx, mbuf[0].dy)
end
print(mouse_file)

lib.bcm_host_deinit()
print('end')
    
