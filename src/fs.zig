fn fsWriter (name: []const u8) {
    fn write(value: any) {
   sts.fs.cwd().openFile(name, .{} )
   file.writer().writeStuct(value)
    }

}