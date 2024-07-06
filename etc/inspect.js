print = (stack) => {
    let out = '';
    let ptr = stack.ptr();
    for(let i = (~Math.abs(ptr - 7)) & 0xff; i != ptr + 1; i = (i + 1) % 256) {
        let byte = stack.get(i);
        byte = byte.toString(16);
        byte = byte.length == 1 ? ("0" + byte) : byte;
        out = out + byte + (i == 0 ? '|' : ' ');
    }
    return out + "< \n";
}

inspect = (uxn) => {
	console.error("WST " + print(uxn.wst));
	console.error("RST " + print(uxn.rst));
}
