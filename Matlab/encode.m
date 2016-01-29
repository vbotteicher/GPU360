function [rt,gt,bt,at] = encode(v)

rt = single(single(v)*256*256*256 - floor(single(v)*256*256*256));
gt = single(single(v)*256*256 - floor(single(v)*256*256));
bt = single(single(v)*256 - floor(single(v)*256));
at = single(single(v) - floor(single(v)));

rt = single(rt - rt*0);
gt = single(gt - single(rt)/256);
bt = single(bt - single(gt)/256);
at = single(at - single(bt)/256);