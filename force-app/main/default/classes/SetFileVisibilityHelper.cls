public class SetFileVisibilityHelper {
    public static String FileSizeToString(Long Value) {
        Decimal mb;
       if (Value >= (1024*1024) && Value < (1024*1024*1024))
            {
              mb = Decimal.valueOf(Value);
              mb = mb.divide((1024*1024),2);
             system.debug('mb='+mb);
            }
         return string.valueOf(mb) + ' MB';
    }
}