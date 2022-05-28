
./target/kernel/x86_64-unknown-none-gnu/debug/kernel:     file format elf64-x86-64


Disassembly of section .text:

ffffffffc0010000 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E>:
ffffffffc0010000:	55                   	push   rbp
ffffffffc0010001:	41 57                	push   r15
ffffffffc0010003:	41 56                	push   r14
ffffffffc0010005:	41 55                	push   r13
ffffffffc0010007:	41 54                	push   r12
ffffffffc0010009:	53                   	push   rbx
ffffffffc001000a:	48 81 ec c8 00 00 00 	sub    rsp,0xc8
ffffffffc0010011:	48 89 fb             	mov    rbx,rdi
ffffffffc0010014:	e8 f7 2e 00 00       	call   ffffffffc0012f10 <_ZN5amd649registers3CR04read17h88cde8e597b97367E>
ffffffffc0010019:	25 3f 00 04 e0       	and    eax,0xe004003f
ffffffffc001001e:	48 89 c7             	mov    rdi,rax
ffffffffc0010021:	e8 fa 2e 00 00       	call   ffffffffc0012f20 <_ZN5amd649registers3CR05write17h996a4ee17b157f79E>
ffffffffc0010026:	4c 8b 2b             	mov    r13,QWORD PTR [rbx]
ffffffffc0010029:	4c 8b 63 08          	mov    r12,QWORD PTR [rbx+0x8]
ffffffffc001002d:	4d 39 e5             	cmp    r13,r12
ffffffffc0010030:	0f 84 1a 06 00 00    	je     ffffffffc0010650 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x650>
ffffffffc0010036:	31 c9                	xor    ecx,ecx
ffffffffc0010038:	4c 8d 44 24 08       	lea    r8,[rsp+0x8]
ffffffffc001003d:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0010042:	4c 89 ef             	mov    rdi,r13
ffffffffc0010045:	66 66 2e 0f 1f 84 00 	data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001004c:	00 00 00 00 
ffffffffc0010050:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
ffffffffc0010054:	48 8d 6f 10          	lea    rbp,[rdi+0x10]
ffffffffc0010058:	48 89 d3             	mov    rbx,rdx
ffffffffc001005b:	48 83 e3 f0          	and    rbx,0xfffffffffffffff0
ffffffffc001005f:	f6 c2 01             	test   dl,0x1
ffffffffc0010062:	49 0f 44 f8          	cmove  rdi,r8
ffffffffc0010066:	48 0f 45 c3          	cmovne rax,rbx
ffffffffc001006a:	48 0f 45 ce          	cmovne rcx,rsi
ffffffffc001006e:	48 8b 1f             	mov    rbx,QWORD PTR [rdi]
ffffffffc0010071:	48 89 ef             	mov    rdi,rbp
ffffffffc0010074:	48 89 5c 24 08       	mov    QWORD PTR [rsp+0x8],rbx
ffffffffc0010079:	4c 39 e5             	cmp    rbp,r12
ffffffffc001007c:	75 d2                	jne    ffffffffc0010050 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x50>
ffffffffc001007e:	48 85 c9             	test   rcx,rcx
ffffffffc0010081:	0f 84 c9 05 00 00    	je     ffffffffc0010650 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x650>
ffffffffc0010087:	48 01 c3             	add    rbx,rax
ffffffffc001008a:	0f 82 e2 04 00 00    	jb     ffffffffc0010572 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x572>
ffffffffc0010090:	4c 89 e9             	mov    rcx,r13
ffffffffc0010093:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001009a:	84 00 00 00 00 00 
ffffffffc00100a0:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
ffffffffc00100a4:	a8 01                	test   al,0x1
ffffffffc00100a6:	75 23                	jne    ffffffffc00100cb <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0xcb>
ffffffffc00100a8:	48 83 c1 10          	add    rcx,0x10
ffffffffc00100ac:	4c 39 e1             	cmp    rcx,r12
ffffffffc00100af:	75 ef                	jne    ffffffffc00100a0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0xa0>
ffffffffc00100b1:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc00100b6:	48 c7 c7 10 5f 01 c0 	mov    rdi,0xffffffffc0015f10
ffffffffc00100bd:	48 c7 c2 20 60 01 c0 	mov    rdx,0xffffffffc0016020
ffffffffc00100c4:	e8 67 45 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00100c9:	0f 0b                	ud2    
ffffffffc00100cb:	4c 8b 31             	mov    r14,QWORD PTR [rcx]
ffffffffc00100ce:	48 83 c1 10          	add    rcx,0x10
ffffffffc00100d2:	4c 39 e1             	cmp    rcx,r12
ffffffffc00100d5:	74 30                	je     ffffffffc0010107 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x107>
ffffffffc00100d7:	48 83 e0 f0          	and    rax,0xfffffffffffffff0
ffffffffc00100db:	eb 0b                	jmp    ffffffffc00100e8 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0xe8>
ffffffffc00100dd:	0f 1f 00             	nop    DWORD PTR [rax]
ffffffffc00100e0:	48 89 d1             	mov    rcx,rdx
ffffffffc00100e3:	4c 39 e2             	cmp    rdx,r12
ffffffffc00100e6:	74 1f                	je     ffffffffc0010107 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x107>
ffffffffc00100e8:	48 8b 71 08          	mov    rsi,QWORD PTR [rcx+0x8]
ffffffffc00100ec:	48 8d 51 10          	lea    rdx,[rcx+0x10]
ffffffffc00100f0:	40 f6 c6 01          	test   sil,0x1
ffffffffc00100f4:	74 ea                	je     ffffffffc00100e0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0xe0>
ffffffffc00100f6:	48 83 e6 f0          	and    rsi,0xfffffffffffffff0
ffffffffc00100fa:	48 39 f0             	cmp    rax,rsi
ffffffffc00100fd:	77 e1                	ja     ffffffffc00100e0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0xe0>
ffffffffc00100ff:	4c 8b 31             	mov    r14,QWORD PTR [rcx]
ffffffffc0010102:	48 89 f0             	mov    rax,rsi
ffffffffc0010105:	eb d9                	jmp    ffffffffc00100e0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0xe0>
ffffffffc0010107:	4c 89 f7             	mov    rdi,r14
ffffffffc001010a:	48 81 c7 00 10 00 00 	add    rdi,0x1000
ffffffffc0010111:	0f 82 75 04 00 00    	jb     ffffffffc001058c <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x58c>
ffffffffc0010117:	48 ff cf             	dec    rdi
ffffffffc001011a:	48 81 e7 00 f0 ff ff 	and    rdi,0xfffffffffffff000
ffffffffc0010121:	48 89 fd             	mov    rbp,rdi
ffffffffc0010124:	48 81 c5 00 10 00 00 	add    rbp,0x1000
ffffffffc001012b:	0f 82 0d 04 00 00    	jb     ffffffffc001053e <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x53e>
ffffffffc0010131:	4c 01 f7             	add    rdi,r14
ffffffffc0010134:	0f 82 1e 04 00 00    	jb     ffffffffc0010558 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x558>
ffffffffc001013a:	0f 84 2a 05 00 00    	je     ffffffffc001066a <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x66a>
ffffffffc0010140:	89 f8                	mov    eax,edi
ffffffffc0010142:	83 e0 07             	and    eax,0x7
ffffffffc0010145:	48 85 c0             	test   rax,rax
ffffffffc0010148:	0f 85 1c 05 00 00    	jne    ffffffffc001066a <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x66a>
ffffffffc001014e:	ba 00 10 00 00       	mov    edx,0x1000
ffffffffc0010153:	31 f6                	xor    esi,esi
ffffffffc0010155:	48 89 3c 24          	mov    QWORD PTR [rsp],rdi
ffffffffc0010159:	e8 52 5d 00 00       	call   ffffffffc0015eb0 <memset>
ffffffffc001015e:	49 89 ef             	mov    r15,rbp
ffffffffc0010161:	49 81 c7 00 10 00 00 	add    r15,0x1000
ffffffffc0010168:	0f 82 d0 03 00 00    	jb     ffffffffc001053e <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x53e>
ffffffffc001016e:	4c 01 f5             	add    rbp,r14
ffffffffc0010171:	0f 82 e1 03 00 00    	jb     ffffffffc0010558 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x558>
ffffffffc0010177:	0f 84 ed 04 00 00    	je     ffffffffc001066a <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x66a>
ffffffffc001017d:	89 e8                	mov    eax,ebp
ffffffffc001017f:	83 e0 07             	and    eax,0x7
ffffffffc0010182:	48 85 c0             	test   rax,rax
ffffffffc0010185:	0f 85 df 04 00 00    	jne    ffffffffc001066a <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x66a>
ffffffffc001018b:	ba 00 10 00 00       	mov    edx,0x1000
ffffffffc0010190:	48 89 ef             	mov    rdi,rbp
ffffffffc0010193:	31 f6                	xor    esi,esi
ffffffffc0010195:	e8 16 5d 00 00       	call   ffffffffc0015eb0 <memset>
ffffffffc001019a:	48 b8 ff 0f 00 00 00 	movabs rax,0xfff0000000000fff
ffffffffc00101a1:	00 f0 ff 
ffffffffc00101a4:	48 85 c5             	test   rbp,rax
ffffffffc00101a7:	0f 85 e9 00 00 00    	jne    ffffffffc0010296 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x296>
ffffffffc00101ad:	48 8b 0c 24          	mov    rcx,QWORD PTR [rsp]
ffffffffc00101b1:	48 89 e8             	mov    rax,rbp
ffffffffc00101b4:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc00101b9:	48 83 c8 03          	or     rax,0x3
ffffffffc00101bd:	48 89 81 f8 0f 00 00 	mov    QWORD PTR [rcx+0xff8],rax
ffffffffc00101c4:	e8 97 2d 00 00       	call   ffffffffc0012f60 <_ZN5amd649registers3CR34read17h27ce5027a3a848dcE>
ffffffffc00101c9:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
ffffffffc00101ce:	48 b9 00 f0 ff ff ff 	movabs rcx,0xffffffffff000
ffffffffc00101d5:	ff 0f 00 
ffffffffc00101d8:	4c 89 fe             	mov    rsi,r15
ffffffffc00101db:	48 8b 80 f8 0f 00 00 	mov    rax,QWORD PTR [rax+0xff8]
ffffffffc00101e2:	48 21 c8             	and    rax,rcx
ffffffffc00101e5:	48 23 88 f8 0f 00 00 	and    rcx,QWORD PTR [rax+0xff8]
ffffffffc00101ec:	48 83 c9 03          	or     rcx,0x3
ffffffffc00101f0:	48 81 c6 00 10 00 00 	add    rsi,0x1000
ffffffffc00101f7:	48 89 8d f8 0f 00 00 	mov    QWORD PTR [rbp+0xff8],rcx
ffffffffc00101fe:	0f 82 3a 03 00 00    	jb     ffffffffc001053e <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x53e>
ffffffffc0010204:	4d 01 f7             	add    r15,r14
ffffffffc0010207:	0f 82 4b 03 00 00    	jb     ffffffffc0010558 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x558>
ffffffffc001020d:	48 b8 ff 0f 00 00 00 	movabs rax,0xfff0000000000fff
ffffffffc0010214:	00 f0 ff 
ffffffffc0010217:	49 85 c7             	test   r15,rax
ffffffffc001021a:	75 7a                	jne    ffffffffc0010296 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x296>
ffffffffc001021c:	48 8b 3c 24          	mov    rdi,QWORD PTR [rsp]
ffffffffc0010220:	4c 89 f9             	mov    rcx,r15
ffffffffc0010223:	48 89 da             	mov    rdx,rbx
ffffffffc0010226:	48 8d 83 00 00 00 40 	lea    rax,[rbx+0x40000000]
ffffffffc001022d:	48 83 c9 03          	or     rcx,0x3
ffffffffc0010231:	48 81 c2 00 00 00 40 	add    rdx,0x40000000
ffffffffc0010238:	48 89 8f 00 08 00 00 	mov    QWORD PTR [rdi+0x800],rcx
ffffffffc001023f:	0f 82 61 03 00 00    	jb     ffffffffc00105a6 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x5a6>
ffffffffc0010245:	48 ff c8             	dec    rax
ffffffffc0010248:	48 89 74 24 58       	mov    QWORD PTR [rsp+0x58],rsi
ffffffffc001024d:	b9 83 00 00 00       	mov    ecx,0x83
ffffffffc0010252:	31 d2                	xor    edx,edx
ffffffffc0010254:	48 be 00 00 c0 ff 01 	movabs rsi,0x1ffc00000
ffffffffc001025b:	00 00 00 
ffffffffc001025e:	48 c1 e8 1e          	shr    rax,0x1e
ffffffffc0010262:	eb 25                	jmp    ffffffffc0010289 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x289>
ffffffffc0010264:	66 66 66 2e 0f 1f 84 	data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001026b:	00 00 00 00 00 
ffffffffc0010270:	31 ed                	xor    ebp,ebp
ffffffffc0010272:	49 89 2c d7          	mov    QWORD PTR [r15+rdx*8],rbp
ffffffffc0010276:	48 ff c2             	inc    rdx
ffffffffc0010279:	48 81 c1 00 00 00 40 	add    rcx,0x40000000
ffffffffc0010280:	48 81 fa 00 02 00 00 	cmp    rdx,0x200
ffffffffc0010287:	74 4d                	je     ffffffffc00102d6 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x2d6>
ffffffffc0010289:	48 39 c2             	cmp    rdx,rax
ffffffffc001028c:	73 e2                	jae    ffffffffc0010270 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x270>
ffffffffc001028e:	48 89 cd             	mov    rbp,rcx
ffffffffc0010291:	48 85 f2             	test   rdx,rsi
ffffffffc0010294:	74 dc                	je     ffffffffc0010272 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x272>
ffffffffc0010296:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc001029b:	48 c7 c6 c0 5f 01 c0 	mov    rsi,0xffffffffc0015fc0
ffffffffc00102a2:	48 c7 44 24 08 80 5f 	mov    QWORD PTR [rsp+0x8],0xffffffffc0015f80
ffffffffc00102a9:	01 c0 
ffffffffc00102ab:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc00102b2:	00 00 
ffffffffc00102b4:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc00102bb:	00 00 
ffffffffc00102bd:	48 c7 44 24 28 10 5f 	mov    QWORD PTR [rsp+0x28],0xffffffffc0015f10
ffffffffc00102c4:	01 c0 
ffffffffc00102c6:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc00102cd:	00 00 
ffffffffc00102cf:	e8 2c 44 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc00102d4:	0f 0b                	ud2    
ffffffffc00102d6:	e8 55 2c 00 00       	call   ffffffffc0012f30 <_ZN5amd649registers3CR310set_nflags17hd29ca20d6e88193eE>
ffffffffc00102db:	e8 30 2c 00 00       	call   ffffffffc0012f10 <_ZN5amd649registers3CR04read17h88cde8e597b97367E>
ffffffffc00102e0:	48 0d 00 00 01 00    	or     rax,0x10000
ffffffffc00102e6:	48 89 c7             	mov    rdi,rax
ffffffffc00102e9:	e8 32 2c 00 00       	call   ffffffffc0012f20 <_ZN5amd649registers3CR05write17h996a4ee17b157f79E>
ffffffffc00102ee:	be 00 10 00 00       	mov    esi,0x1000
ffffffffc00102f3:	48 89 df             	mov    rdi,rbx
ffffffffc00102f6:	e8 c5 0f 00 00       	call   ffffffffc00112c0 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E>
ffffffffc00102fb:	4c 8b 44 24 58       	mov    r8,QWORD PTR [rsp+0x58]
ffffffffc0010300:	4d 89 c7             	mov    r15,r8
ffffffffc0010303:	49 81 c7 00 10 00 00 	add    r15,0x1000
ffffffffc001030a:	0f 82 2e 02 00 00    	jb     ffffffffc001053e <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x53e>
ffffffffc0010310:	4d 01 f0             	add    r8,r14
ffffffffc0010313:	0f 82 3f 02 00 00    	jb     ffffffffc0010558 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x558>
ffffffffc0010319:	48 b9 00 00 00 00 00 	movabs rcx,0xffff800000000000
ffffffffc0010320:	80 ff ff 
ffffffffc0010323:	49 89 c1             	mov    r9,rax
ffffffffc0010326:	49 01 c8             	add    r8,rcx
ffffffffc0010329:	0f 80 91 02 00 00    	jo     ffffffffc00105c0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x5c0>
ffffffffc001032f:	b9 10 00 00 00       	mov    ecx,0x10
ffffffffc0010334:	4c 89 c8             	mov    rax,r9
ffffffffc0010337:	49 89 d2             	mov    r10,rdx
ffffffffc001033a:	48 f7 e1             	mul    rcx
ffffffffc001033d:	0f 80 97 02 00 00    	jo     ffffffffc00105da <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x5da>
ffffffffc0010343:	4c 01 d0             	add    rax,r10
ffffffffc0010346:	0f 82 9c 02 00 00    	jb     ffffffffc00105e8 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x5e8>
ffffffffc001034c:	48 83 e8 01          	sub    rax,0x1
ffffffffc0010350:	0f 82 ac 02 00 00    	jb     ffffffffc0010602 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x602>
ffffffffc0010356:	48 25 00 f0 ff ff    	and    rax,0xfffffffffffff000
ffffffffc001035c:	49 01 c7             	add    r15,rax
ffffffffc001035f:	0f 82 b7 02 00 00    	jb     ffffffffc001061c <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x61c>
ffffffffc0010365:	4c 89 c8             	mov    rax,r9
ffffffffc0010368:	48 8d 6c 24 78       	lea    rbp,[rsp+0x78]
ffffffffc001036d:	b9 00 10 00 00       	mov    ecx,0x1000
ffffffffc0010372:	48 be 00 00 00 00 00 	movabs rsi,0xffff800000000000
ffffffffc0010379:	80 ff ff 
ffffffffc001037c:	48 89 da             	mov    rdx,rbx
ffffffffc001037f:	48 c1 e0 04          	shl    rax,0x4
ffffffffc0010383:	48 89 ef             	mov    rdi,rbp
ffffffffc0010386:	4c 01 c0             	add    rax,r8
ffffffffc0010389:	41 52                	push   r10
ffffffffc001038b:	50                   	push   rax
ffffffffc001038c:	e8 2f 10 00 00       	call   ffffffffc00113c0 <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE>
ffffffffc0010391:	48 83 c4 10          	add    rsp,0x10
ffffffffc0010395:	4d 01 f7             	add    r15,r14
ffffffffc0010398:	0f 93 c3             	setae  bl
ffffffffc001039b:	eb 0c                	jmp    ffffffffc00103a9 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x3a9>
ffffffffc001039d:	0f 1f 00             	nop    DWORD PTR [rax]
ffffffffc00103a0:	4d 39 e5             	cmp    r13,r12
ffffffffc00103a3:	0f 84 85 00 00 00    	je     ffffffffc001042e <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x42e>
ffffffffc00103a9:	49 83 c5 10          	add    r13,0x10
ffffffffc00103ad:	49 8b 45 f8          	mov    rax,QWORD PTR [r13-0x8]
ffffffffc00103b1:	a8 01                	test   al,0x1
ffffffffc00103b3:	74 eb                	je     ffffffffc00103a0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x3a0>
ffffffffc00103b5:	49 8b 55 f0          	mov    rdx,QWORD PTR [r13-0x10]
ffffffffc00103b9:	4c 39 f2             	cmp    rdx,r14
ffffffffc00103bc:	0f 95 c1             	setne  cl
ffffffffc00103bf:	08 d9                	or     cl,bl
ffffffffc00103c1:	80 f9 01             	cmp    cl,0x1
ffffffffc00103c4:	0f 85 5a 01 00 00    	jne    ffffffffc0010524 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x524>
ffffffffc00103ca:	4c 39 f2             	cmp    rdx,r14
ffffffffc00103cd:	48 b9 00 00 00 00 00 	movabs rcx,0xffff800000000000
ffffffffc00103d4:	80 ff ff 
ffffffffc00103d7:	49 0f 44 d7          	cmove  rdx,r15
ffffffffc00103db:	48 01 ca             	add    rdx,rcx
ffffffffc00103de:	0f 80 d8 00 00 00    	jo     ffffffffc00104bc <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x4bc>
ffffffffc00103e4:	48 8b 8c 24 90 00 00 	mov    rcx,QWORD PTR [rsp+0x90]
ffffffffc00103eb:	00 
ffffffffc00103ec:	48 83 e0 f0          	and    rax,0xfffffffffffffff0
ffffffffc00103f0:	48 39 c1             	cmp    rcx,rax
ffffffffc00103f3:	0f 87 3d 02 00 00    	ja     ffffffffc0010636 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x636>
ffffffffc00103f9:	48 83 e9 01          	sub    rcx,0x1
ffffffffc00103fd:	0f 82 d3 00 00 00    	jb     ffffffffc00104d6 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x4d6>
ffffffffc0010403:	48 89 d6             	mov    rsi,rdx
ffffffffc0010406:	48 01 ce             	add    rsi,rcx
ffffffffc0010409:	0f 80 e1 00 00 00    	jo     ffffffffc00104f0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x4f0>
ffffffffc001040f:	48 01 c2             	add    rdx,rax
ffffffffc0010412:	0f 80 f2 00 00 00    	jo     ffffffffc001050a <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x50a>
ffffffffc0010418:	48 f7 d1             	not    rcx
ffffffffc001041b:	48 89 ef             	mov    rdi,rbp
ffffffffc001041e:	48 21 ce             	and    rsi,rcx
ffffffffc0010421:	48 21 ca             	and    rdx,rcx
ffffffffc0010424:	e8 17 11 00 00       	call   ffffffffc0011540 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E>
ffffffffc0010429:	e9 72 ff ff ff       	jmp    ffffffffc00103a0 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x3a0>
ffffffffc001042e:	48 8d 7c 24 60       	lea    rdi,[rsp+0x60]
ffffffffc0010433:	e8 28 2b 00 00       	call   ffffffffc0012f60 <_ZN5amd649registers3CR34read17h27ce5027a3a848dcE>
ffffffffc0010438:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc001043d:	48 8d 74 24 78       	lea    rsi,[rsp+0x78]
ffffffffc0010442:	b9 0a 00 00 00       	mov    ecx,0xa
ffffffffc0010447:	48 8b 54 24 70       	mov    rdx,QWORD PTR [rsp+0x70]
ffffffffc001044c:	f3 48 a5             	rep movs QWORD PTR es:[rdi],QWORD PTR ds:[rsi]
ffffffffc001044f:	b1 01                	mov    cl,0x1
ffffffffc0010451:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0010458:	0f 1f 84 00 00 00 00 
ffffffffc001045f:	00 
ffffffffc0010460:	31 c0                	xor    eax,eax
ffffffffc0010462:	f0 0f b0 0d 8e 91 00 	lock cmpxchg BYTE PTR [rip+0x918e],cl        # ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>
ffffffffc0010469:	00 
ffffffffc001046a:	74 0d                	je     ffffffffc0010479 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x479>
ffffffffc001046c:	0f b6 05 85 91 00 00 	movzx  eax,BYTE PTR [rip+0x9185]        # ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>
ffffffffc0010473:	84 c0                	test   al,al
ffffffffc0010475:	75 f5                	jne    ffffffffc001046c <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x46c>
ffffffffc0010477:	eb e7                	jmp    ffffffffc0010460 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x460>
ffffffffc0010479:	48 89 15 80 91 00 00 	mov    QWORD PTR [rip+0x9180],rdx        # ffffffffc0019600 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E+0x8>
ffffffffc0010480:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0010485:	b9 0a 00 00 00       	mov    ecx,0xa
ffffffffc001048a:	48 c7 c7 08 96 01 c0 	mov    rdi,0xffffffffc0019608
ffffffffc0010491:	f3 48 a5             	rep movs QWORD PTR es:[rdi],QWORD PTR ds:[rsi]
ffffffffc0010494:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0010499:	c6 05 58 91 00 00 00 	mov    BYTE PTR [rip+0x9158],0x0        # ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>
ffffffffc00104a0:	e8 bb 2a 00 00       	call   ffffffffc0012f60 <_ZN5amd649registers3CR34read17h27ce5027a3a848dcE>
ffffffffc00104a5:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
ffffffffc00104aa:	48 81 c4 c8 00 00 00 	add    rsp,0xc8
ffffffffc00104b1:	5b                   	pop    rbx
ffffffffc00104b2:	41 5c                	pop    r12
ffffffffc00104b4:	41 5d                	pop    r13
ffffffffc00104b6:	41 5e                	pop    r14
ffffffffc00104b8:	41 5f                	pop    r15
ffffffffc00104ba:	5d                   	pop    rbp
ffffffffc00104bb:	c3                   	ret    
ffffffffc00104bc:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00104c1:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc00104c8:	48 c7 c2 30 61 01 c0 	mov    rdx,0xffffffffc0016130
ffffffffc00104cf:	e8 5c 41 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00104d4:	0f 0b                	ud2    
ffffffffc00104d6:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00104db:	48 c7 c7 50 60 01 c0 	mov    rdi,0xffffffffc0016050
ffffffffc00104e2:	48 c7 c2 08 62 01 c0 	mov    rdx,0xffffffffc0016208
ffffffffc00104e9:	e8 42 41 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00104ee:	0f 0b                	ud2    
ffffffffc00104f0:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00104f5:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc00104fc:	48 c7 c2 20 62 01 c0 	mov    rdx,0xffffffffc0016220
ffffffffc0010503:	e8 28 41 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010508:	0f 0b                	ud2    
ffffffffc001050a:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001050f:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc0010516:	48 c7 c2 38 62 01 c0 	mov    rdx,0xffffffffc0016238
ffffffffc001051d:	e8 0e 41 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010522:	0f 0b                	ud2    
ffffffffc0010524:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0010529:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc0010530:	48 c7 c2 18 61 01 c0 	mov    rdx,0xffffffffc0016118
ffffffffc0010537:	e8 f4 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001053c:	0f 0b                	ud2    
ffffffffc001053e:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0010543:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc001054a:	48 c7 c2 48 61 01 c0 	mov    rdx,0xffffffffc0016148
ffffffffc0010551:	e8 da 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010556:	0f 0b                	ud2    
ffffffffc0010558:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001055d:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc0010564:	48 c7 c2 60 61 01 c0 	mov    rdx,0xffffffffc0016160
ffffffffc001056b:	e8 c0 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010570:	0f 0b                	ud2    
ffffffffc0010572:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0010577:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc001057e:	48 c7 c2 78 61 01 c0 	mov    rdx,0xffffffffc0016178
ffffffffc0010585:	e8 a6 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001058a:	0f 0b                	ud2    
ffffffffc001058c:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0010591:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc0010598:	48 c7 c2 38 60 01 c0 	mov    rdx,0xffffffffc0016038
ffffffffc001059f:	e8 8c 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00105a4:	0f 0b                	ud2    
ffffffffc00105a6:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00105ab:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc00105b2:	48 c7 c2 78 60 01 c0 	mov    rdx,0xffffffffc0016078
ffffffffc00105b9:	e8 72 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00105be:	0f 0b                	ud2    
ffffffffc00105c0:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00105c5:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc00105cc:	48 c7 c2 b8 60 01 c0 	mov    rdx,0xffffffffc00160b8
ffffffffc00105d3:	e8 58 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00105d8:	0f 0b                	ud2    
ffffffffc00105da:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00105df:	48 c7 c7 90 60 01 c0 	mov    rdi,0xffffffffc0016090
ffffffffc00105e6:	eb 0c                	jmp    ffffffffc00105f4 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E+0x5f4>
ffffffffc00105e8:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00105ed:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc00105f4:	48 c7 c2 d0 60 01 c0 	mov    rdx,0xffffffffc00160d0
ffffffffc00105fb:	e8 30 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010600:	0f 0b                	ud2    
ffffffffc0010602:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0010607:	48 c7 c7 50 60 01 c0 	mov    rdi,0xffffffffc0016050
ffffffffc001060e:	48 c7 c2 e8 60 01 c0 	mov    rdx,0xffffffffc00160e8
ffffffffc0010615:	e8 16 40 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001061a:	0f 0b                	ud2    
ffffffffc001061c:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0010621:	48 c7 c7 f0 5e 01 c0 	mov    rdi,0xffffffffc0015ef0
ffffffffc0010628:	48 c7 c2 00 61 01 c0 	mov    rdx,0xffffffffc0016100
ffffffffc001062f:	e8 fc 3f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010634:	0f 0b                	ud2    
ffffffffc0010636:	be 2a 00 00 00       	mov    esi,0x2a
ffffffffc001063b:	48 c7 c7 90 61 01 c0 	mov    rdi,0xffffffffc0016190
ffffffffc0010642:	48 c7 c2 f0 61 01 c0 	mov    rdx,0xffffffffc00161f0
ffffffffc0010649:	e8 e2 3f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001064e:	0f 0b                	ud2    
ffffffffc0010650:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc0010655:	48 c7 c7 10 5f 01 c0 	mov    rdi,0xffffffffc0015f10
ffffffffc001065c:	48 c7 c2 08 60 01 c0 	mov    rdx,0xffffffffc0016008
ffffffffc0010663:	e8 c8 3f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010668:	0f 0b                	ud2    
ffffffffc001066a:	0f 0b                	ud2    
ffffffffc001066c:	0f 0b                	ud2    
ffffffffc001066e:	cc                   	int3   
ffffffffc001066f:	cc                   	int3   

ffffffffc0010670 <_start>:
ffffffffc0010670:	55                   	push   rbp
ffffffffc0010671:	41 57                	push   r15
ffffffffc0010673:	41 56                	push   r14
ffffffffc0010675:	41 55                	push   r13
ffffffffc0010677:	41 54                	push   r12
ffffffffc0010679:	53                   	push   rbx
ffffffffc001067a:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc0010681:	48 bf 06 04 07 00 01 	movabs rdi,0x707050100070406
ffffffffc0010688:	05 07 07 
ffffffffc001068b:	e8 30 29 00 00       	call   ffffffffc0012fc0 <_ZN5amd646paging3Pat5write17h0d0070c1f1203b57E>
ffffffffc0010690:	b8 01 00 00 00       	mov    eax,0x1
ffffffffc0010695:	f0 48 0f c1 05 62 99 	lock xadd QWORD PTR [rip+0x9962],rax        # ffffffffc001a000 <_ZN6kernel6_start13THREAD_TICKET17he1863cb4ed3aa7ceE>
ffffffffc001069c:	00 00 
ffffffffc001069e:	48 89 44 24 70       	mov    QWORD PTR [rsp+0x70],rax
ffffffffc00106a3:	48 85 c0             	test   rax,rax
ffffffffc00106a6:	0f 85 04 02 00 00    	jne    ffffffffc00108b0 <_start+0x240>
ffffffffc00106ac:	48 8d 44 24 40       	lea    rax,[rsp+0x40]
ffffffffc00106b1:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc00106b6:	48 89 e5             	mov    rbp,rsp
ffffffffc00106b9:	48 c7 44 24 40 a0 62 	mov    QWORD PTR [rsp+0x40],0xffffffffc00162a0
ffffffffc00106c0:	01 c0 
ffffffffc00106c2:	48 c7 44 24 48 01 00 	mov    QWORD PTR [rsp+0x48],0x1
ffffffffc00106c9:	00 00 
ffffffffc00106cb:	48 c7 44 24 50 00 00 	mov    QWORD PTR [rsp+0x50],0x0
ffffffffc00106d2:	00 00 
ffffffffc00106d4:	48 c7 44 24 60 70 62 	mov    QWORD PTR [rsp+0x60],0xffffffffc0016270
ffffffffc00106db:	01 c0 
ffffffffc00106dd:	48 c7 44 24 10 78 62 	mov    QWORD PTR [rsp+0x10],0xffffffffc0016278
ffffffffc00106e4:	01 c0 
ffffffffc00106e6:	48 c7 44 24 18 01 00 	mov    QWORD PTR [rsp+0x18],0x1
ffffffffc00106ed:	00 00 
ffffffffc00106ef:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
ffffffffc00106f6:	00 00 
ffffffffc00106f8:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc00106ff:	00 00 
ffffffffc0010701:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc0010705:	48 89 6c 24 30       	mov    QWORD PTR [rsp+0x30],rbp
ffffffffc001070a:	48 c7 44 24 08 a0 32 	mov    QWORD PTR [rsp+0x8],0xffffffffc00132a0
ffffffffc0010711:	01 c0 
ffffffffc0010713:	48 c7 44 24 38 01 00 	mov    QWORD PTR [rsp+0x38],0x1
ffffffffc001071a:	00 00 
ffffffffc001071c:	e8 ff 25 00 00       	call   ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>
ffffffffc0010721:	8b 04 25 04 00 e0 ff 	mov    eax,DWORD PTR ds:0xffffffffffe00004
ffffffffc0010728:	48 2d 90 00 00 00    	sub    rax,0x90
ffffffffc001072e:	0f 82 f8 02 00 00    	jb     ffffffffc0010a2c <_start+0x3bc>
ffffffffc0010734:	48 83 e0 f0          	and    rax,0xfffffffffffffff0
ffffffffc0010738:	48 8d 5c 24 40       	lea    rbx,[rsp+0x40]
ffffffffc001073d:	48 c7 44 24 40 90 00 	mov    QWORD PTR [rsp+0x40],0xffffffffffe00090
ffffffffc0010744:	e0 ff 
ffffffffc0010746:	48 05 90 00 e0 ff    	add    rax,0xffffffffffe00090
ffffffffc001074c:	48 89 df             	mov    rdi,rbx
ffffffffc001074f:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
ffffffffc0010754:	e8 a7 f8 ff ff       	call   ffffffffc0010000 <_ZN9libkernel4memm6Mapper5setup17h9b09336dcd206044E>
ffffffffc0010759:	48 87 05 50 8e 00 00 	xchg   QWORD PTR [rip+0x8e50],rax        # ffffffffc00195b0 <_ZN6kernel6_start20IS_MAPPER_INITD_PML417ha7145abaf1b86d3dE.0>
ffffffffc0010760:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc0010765:	48 c7 44 24 40 10 63 	mov    QWORD PTR [rsp+0x40],0xffffffffc0016310
ffffffffc001076c:	01 c0 
ffffffffc001076e:	48 c7 44 24 48 01 00 	mov    QWORD PTR [rsp+0x48],0x1
ffffffffc0010775:	00 00 
ffffffffc0010777:	48 c7 44 24 50 00 00 	mov    QWORD PTR [rsp+0x50],0x0
ffffffffc001077e:	00 00 
ffffffffc0010780:	48 c7 44 24 60 70 62 	mov    QWORD PTR [rsp+0x60],0xffffffffc0016270
ffffffffc0010787:	01 c0 
ffffffffc0010789:	48 89 1c 24          	mov    QWORD PTR [rsp],rbx
ffffffffc001078d:	48 c7 44 24 10 78 62 	mov    QWORD PTR [rsp+0x10],0xffffffffc0016278
ffffffffc0010794:	01 c0 
ffffffffc0010796:	48 c7 44 24 18 01 00 	mov    QWORD PTR [rsp+0x18],0x1
ffffffffc001079d:	00 00 
ffffffffc001079f:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
ffffffffc00107a6:	00 00 
ffffffffc00107a8:	48 89 6c 24 30       	mov    QWORD PTR [rsp+0x30],rbp
ffffffffc00107ad:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc00107b4:	00 00 
ffffffffc00107b6:	48 c7 44 24 08 a0 32 	mov    QWORD PTR [rsp+0x8],0xffffffffc00132a0
ffffffffc00107bd:	01 c0 
ffffffffc00107bf:	48 c7 44 24 38 01 00 	mov    QWORD PTR [rsp+0x38],0x1
ffffffffc00107c6:	00 00 
ffffffffc00107c8:	e8 53 25 00 00       	call   ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>
ffffffffc00107cd:	48 8b 3d dc 8d 00 00 	mov    rdi,QWORD PTR [rip+0x8ddc]        # ffffffffc00195b0 <_ZN6kernel6_start20IS_MAPPER_INITD_PML417ha7145abaf1b86d3dE.0>
ffffffffc00107d4:	e8 57 27 00 00       	call   ffffffffc0012f30 <_ZN5amd649registers3CR310set_nflags17hd29ca20d6e88193eE>
ffffffffc00107d9:	b8 00 00 40 00       	mov    eax,0x400000
ffffffffc00107de:	48 f7 64 24 70       	mul    QWORD PTR [rsp+0x70]
ffffffffc00107e3:	0f 80 db 01 00 00    	jo     ffffffffc00109c4 <_start+0x354>
ffffffffc00107e9:	49 c7 c7 00 00 00 c0 	mov    r15,0xffffffffc0000000
ffffffffc00107f0:	49 29 c7             	sub    r15,rax
ffffffffc00107f3:	0f 82 e5 01 00 00    	jb     ffffffffc00109de <_start+0x36e>
ffffffffc00107f9:	4c 8d 64 24 70       	lea    r12,[rsp+0x70]
ffffffffc00107fe:	48 8d 44 24 40       	lea    rax,[rsp+0x40]
ffffffffc0010803:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc0010808:	49 89 e5             	mov    r13,rsp
ffffffffc001080b:	48 8d 6c 24 78       	lea    rbp,[rsp+0x78]
ffffffffc0010810:	48 c7 44 24 40 90 63 	mov    QWORD PTR [rsp+0x40],0xffffffffc0016390
ffffffffc0010817:	01 c0 
ffffffffc0010819:	48 c7 44 24 48 02 00 	mov    QWORD PTR [rsp+0x48],0x2
ffffffffc0010820:	00 00 
ffffffffc0010822:	48 c7 44 24 50 00 00 	mov    QWORD PTR [rsp+0x50],0x0
ffffffffc0010829:	00 00 
ffffffffc001082b:	48 c7 44 24 10 78 62 	mov    QWORD PTR [rsp+0x10],0xffffffffc0016278
ffffffffc0010832:	01 c0 
ffffffffc0010834:	48 c7 44 24 18 01 00 	mov    QWORD PTR [rsp+0x18],0x1
ffffffffc001083b:	00 00 
ffffffffc001083d:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
ffffffffc0010844:	00 00 
ffffffffc0010846:	4c 89 24 24          	mov    QWORD PTR [rsp],r12
ffffffffc001084a:	4c 89 6c 24 60       	mov    QWORD PTR [rsp+0x60],r13
ffffffffc001084f:	48 89 44 24 78       	mov    QWORD PTR [rsp+0x78],rax
ffffffffc0010854:	48 89 6c 24 30       	mov    QWORD PTR [rsp+0x30],rbp
ffffffffc0010859:	48 c7 44 24 08 10 54 	mov    QWORD PTR [rsp+0x8],0xffffffffc0015410
ffffffffc0010860:	01 c0 
ffffffffc0010862:	48 c7 44 24 68 01 00 	mov    QWORD PTR [rsp+0x68],0x1
ffffffffc0010869:	00 00 
ffffffffc001086b:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0xffffffffc00132a0
ffffffffc0010872:	00 a0 32 01 c0 
ffffffffc0010877:	48 c7 44 24 38 01 00 	mov    QWORD PTR [rsp+0x38],0x1
ffffffffc001087e:	00 00 
ffffffffc0010880:	e8 9b 24 00 00       	call   ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>
ffffffffc0010885:	b1 01                	mov    cl,0x1
ffffffffc0010887:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
ffffffffc001088e:	00 00 
ffffffffc0010890:	31 c0                	xor    eax,eax
ffffffffc0010892:	f0 0f b0 0d 5e 8d 00 	lock cmpxchg BYTE PTR [rip+0x8d5e],cl        # ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>
ffffffffc0010899:	00 
ffffffffc001089a:	74 29                	je     ffffffffc00108c5 <_start+0x255>
ffffffffc001089c:	0f b6 05 55 8d 00 00 	movzx  eax,BYTE PTR [rip+0x8d55]        # ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>
ffffffffc00108a3:	84 c0                	test   al,al
ffffffffc00108a5:	75 f5                	jne    ffffffffc001089c <_start+0x22c>
ffffffffc00108a7:	eb e7                	jmp    ffffffffc0010890 <_start+0x220>
ffffffffc00108a9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc00108b0:	48 8b 05 f9 8c 00 00 	mov    rax,QWORD PTR [rip+0x8cf9]        # ffffffffc00195b0 <_ZN6kernel6_start20IS_MAPPER_INITD_PML417ha7145abaf1b86d3dE.0>
ffffffffc00108b7:	48 83 f8 ff          	cmp    rax,0xffffffffffffffff
ffffffffc00108bb:	0f 85 0c ff ff ff    	jne    ffffffffc00107cd <_start+0x15d>
ffffffffc00108c1:	f3 90                	pause  
ffffffffc00108c3:	eb eb                	jmp    ffffffffc00108b0 <_start+0x240>
ffffffffc00108c5:	4c 89 fb             	mov    rbx,r15
ffffffffc00108c8:	48 81 eb 00 f0 3f 00 	sub    rbx,0x3ff000
ffffffffc00108cf:	0f 82 23 01 00 00    	jb     ffffffffc00109f8 <_start+0x388>
ffffffffc00108d5:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc00108da:	e8 81 26 00 00       	call   ffffffffc0012f60 <_ZN5amd649registers3CR34read17h27ce5027a3a848dcE>
ffffffffc00108df:	48 b8 00 00 00 00 00 	movabs rax,0xffff800000000000
ffffffffc00108e6:	80 ff ff 
ffffffffc00108e9:	48 03 44 24 20       	add    rax,QWORD PTR [rsp+0x20]
ffffffffc00108ee:	0f 80 1e 01 00 00    	jo     ffffffffc0010a12 <_start+0x3a2>
ffffffffc00108f4:	4c 8d 74 24 40       	lea    r14,[rsp+0x40]
ffffffffc00108f9:	b9 00 f0 3f 00       	mov    ecx,0x3ff000
ffffffffc00108fe:	41 b8 02 00 00 00    	mov    r8d,0x2
ffffffffc0010904:	41 b9 02 00 00 00    	mov    r9d,0x2
ffffffffc001090a:	48 c7 c6 00 96 01 c0 	mov    rsi,0xffffffffc0019600
ffffffffc0010911:	48 89 da             	mov    rdx,rbx
ffffffffc0010914:	4c 89 f7             	mov    rdi,r14
ffffffffc0010917:	68 00 02 00 00       	push   0x200
ffffffffc001091c:	50                   	push   rax
ffffffffc001091d:	e8 ee 1a 00 00       	call   ffffffffc0012410 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE>
ffffffffc0010922:	48 83 c4 10          	add    rsp,0x10
ffffffffc0010926:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc001092b:	c6 05 c6 8c 00 00 00 	mov    BYTE PTR [rip+0x8cc6],0x0        # ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>
ffffffffc0010932:	4c 89 24 24          	mov    QWORD PTR [rsp],r12
ffffffffc0010936:	48 c7 44 24 40 f0 63 	mov    QWORD PTR [rsp+0x40],0xffffffffc00163f0
ffffffffc001093d:	01 c0 
ffffffffc001093f:	48 c7 44 24 48 02 00 	mov    QWORD PTR [rsp+0x48],0x2
ffffffffc0010946:	00 00 
ffffffffc0010948:	48 c7 44 24 50 00 00 	mov    QWORD PTR [rsp+0x50],0x0
ffffffffc001094f:	00 00 
ffffffffc0010951:	4c 89 6c 24 60       	mov    QWORD PTR [rsp+0x60],r13
ffffffffc0010956:	4c 89 74 24 78       	mov    QWORD PTR [rsp+0x78],r14
ffffffffc001095b:	48 c7 44 24 10 78 62 	mov    QWORD PTR [rsp+0x10],0xffffffffc0016278
ffffffffc0010962:	01 c0 
ffffffffc0010964:	48 c7 44 24 18 01 00 	mov    QWORD PTR [rsp+0x18],0x1
ffffffffc001096b:	00 00 
ffffffffc001096d:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
ffffffffc0010974:	00 00 
ffffffffc0010976:	48 89 6c 24 30       	mov    QWORD PTR [rsp+0x30],rbp
ffffffffc001097b:	48 c7 44 24 08 10 54 	mov    QWORD PTR [rsp+0x8],0xffffffffc0015410
ffffffffc0010982:	01 c0 
ffffffffc0010984:	48 c7 44 24 68 01 00 	mov    QWORD PTR [rsp+0x68],0x1
ffffffffc001098b:	00 00 
ffffffffc001098d:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0xffffffffc00132a0
ffffffffc0010994:	00 a0 32 01 c0 
ffffffffc0010999:	48 c7 44 24 38 01 00 	mov    QWORD PTR [rsp+0x38],0x1
ffffffffc00109a0:	00 00 
ffffffffc00109a2:	e8 79 23 00 00       	call   ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>
ffffffffc00109a7:	48 83 7c 24 70 03    	cmp    QWORD PTR [rsp+0x70],0x3
ffffffffc00109ad:	75 0e                	jne    ffffffffc00109bd <_start+0x34d>
ffffffffc00109af:	49 83 c7 f0          	add    r15,0xfffffffffffffff0
ffffffffc00109b3:	4c 89 fc             	mov    rsp,r15
ffffffffc00109b6:	e8 95 00 00 00       	call   ffffffffc0010a50 <_ZN6kernel4init17hbd3890980e00e55bE>
ffffffffc00109bb:	0f 0b                	ud2    
ffffffffc00109bd:	e8 ee 25 00 00       	call   ffffffffc0012fb0 <_ZN5amd648hlt_loop17hac4b60f2ae618ea8E>
ffffffffc00109c2:	0f 0b                	ud2    
ffffffffc00109c4:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00109c9:	48 c7 c7 40 63 01 c0 	mov    rdi,0xffffffffc0016340
ffffffffc00109d0:	48 c7 c2 20 63 01 c0 	mov    rdx,0xffffffffc0016320
ffffffffc00109d7:	e8 54 3c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00109dc:	0f 0b                	ud2    
ffffffffc00109de:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00109e3:	48 c7 c7 e0 62 01 c0 	mov    rdi,0xffffffffc00162e0
ffffffffc00109ea:	48 c7 c2 68 63 01 c0 	mov    rdx,0xffffffffc0016368
ffffffffc00109f1:	e8 3a 3c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00109f6:	0f 0b                	ud2    
ffffffffc00109f8:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00109fd:	48 c7 c7 e0 62 01 c0 	mov    rdi,0xffffffffc00162e0
ffffffffc0010a04:	48 c7 c2 b0 63 01 c0 	mov    rdx,0xffffffffc00163b0
ffffffffc0010a0b:	e8 20 3c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010a10:	0f 0b                	ud2    
ffffffffc0010a12:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0010a17:	48 c7 c7 50 62 01 c0 	mov    rdi,0xffffffffc0016250
ffffffffc0010a1e:	48 c7 c2 c8 63 01 c0 	mov    rdx,0xffffffffc00163c8
ffffffffc0010a25:	e8 06 3c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010a2a:	0f 0b                	ud2    
ffffffffc0010a2c:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0010a31:	48 c7 c7 e0 62 01 c0 	mov    rdi,0xffffffffc00162e0
ffffffffc0010a38:	48 c7 c2 c8 62 01 c0 	mov    rdx,0xffffffffc00162c8
ffffffffc0010a3f:	e8 ec 3b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010a44:	0f 0b                	ud2    
ffffffffc0010a46:	cc                   	int3   
ffffffffc0010a47:	cc                   	int3   
ffffffffc0010a48:	cc                   	int3   
ffffffffc0010a49:	cc                   	int3   
ffffffffc0010a4a:	cc                   	int3   
ffffffffc0010a4b:	cc                   	int3   
ffffffffc0010a4c:	cc                   	int3   
ffffffffc0010a4d:	cc                   	int3   
ffffffffc0010a4e:	cc                   	int3   
ffffffffc0010a4f:	cc                   	int3   

ffffffffc0010a50 <_ZN6kernel4init17hbd3890980e00e55bE>:
ffffffffc0010a50:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc0010a57:	b8 01 00 00 00       	mov    eax,0x1
ffffffffc0010a5c:	48 89 e2             	mov    rdx,rsp
ffffffffc0010a5f:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc0010a64:	48 8d 7c 24 28       	lea    rdi,[rsp+0x28]
ffffffffc0010a69:	f0 48 0f c1 05 96 95 	lock xadd QWORD PTR [rip+0x9596],rax        # ffffffffc001a008 <_ZN6kernel4init13THREAD_TICKET17hc65c97bb10c21c4fE>
ffffffffc0010a70:	00 00 
ffffffffc0010a72:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
ffffffffc0010a77:	48 c7 44 24 58 40 64 	mov    QWORD PTR [rsp+0x58],0xffffffffc0016440
ffffffffc0010a7e:	01 c0 
ffffffffc0010a80:	48 c7 44 24 60 02 00 	mov    QWORD PTR [rsp+0x60],0x2
ffffffffc0010a87:	00 00 
ffffffffc0010a89:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc0010a90:	00 00 
ffffffffc0010a92:	48 89 4c 24 78       	mov    QWORD PTR [rsp+0x78],rcx
ffffffffc0010a97:	48 8d 54 24 58       	lea    rdx,[rsp+0x58]
ffffffffc0010a9c:	48 8d 4c 24 08       	lea    rcx,[rsp+0x8]
ffffffffc0010aa1:	48 c7 44 24 28 78 62 	mov    QWORD PTR [rsp+0x28],0xffffffffc0016278
ffffffffc0010aa8:	01 c0 
ffffffffc0010aaa:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc0010ab1:	00 00 
ffffffffc0010ab3:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
ffffffffc0010aba:	00 00 
ffffffffc0010abc:	48 c7 44 24 20 10 54 	mov    QWORD PTR [rsp+0x20],0xffffffffc0015410
ffffffffc0010ac3:	01 c0 
ffffffffc0010ac5:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x1
ffffffffc0010acc:	00 01 00 00 00 
ffffffffc0010ad1:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
ffffffffc0010ad6:	48 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],rcx
ffffffffc0010adb:	48 c7 44 24 10 a0 32 	mov    QWORD PTR [rsp+0x10],0xffffffffc00132a0
ffffffffc0010ae2:	01 c0 
ffffffffc0010ae4:	48 c7 44 24 50 01 00 	mov    QWORD PTR [rsp+0x50],0x1
ffffffffc0010aeb:	00 00 
ffffffffc0010aed:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc0010af1:	e8 2a 22 00 00       	call   ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>
ffffffffc0010af6:	e8 b5 24 00 00       	call   ffffffffc0012fb0 <_ZN5amd648hlt_loop17hac4b60f2ae618ea8E>
ffffffffc0010afb:	0f 0b                	ud2    
ffffffffc0010afd:	cc                   	int3   
ffffffffc0010afe:	cc                   	int3   
ffffffffc0010aff:	cc                   	int3   

ffffffffc0010b00 <rust_begin_unwind>:
ffffffffc0010b00:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc0010b07:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc0010b0c:	48 89 3c 24          	mov    QWORD PTR [rsp],rdi
ffffffffc0010b10:	48 89 e0             	mov    rax,rsp
ffffffffc0010b13:	48 c7 44 24 58 60 64 	mov    QWORD PTR [rsp+0x58],0xffffffffc0016460
ffffffffc0010b1a:	01 c0 
ffffffffc0010b1c:	48 c7 44 24 60 01 00 	mov    QWORD PTR [rsp+0x60],0x1
ffffffffc0010b23:	00 00 
ffffffffc0010b25:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc0010b2c:	00 00 
ffffffffc0010b2e:	48 8d 54 24 58       	lea    rdx,[rsp+0x58]
ffffffffc0010b33:	48 8d 7c 24 28       	lea    rdi,[rsp+0x28]
ffffffffc0010b38:	48 c7 44 24 28 78 62 	mov    QWORD PTR [rsp+0x28],0xffffffffc0016278
ffffffffc0010b3f:	01 c0 
ffffffffc0010b41:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc0010b48:	00 00 
ffffffffc0010b4a:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
ffffffffc0010b51:	00 00 
ffffffffc0010b53:	48 89 4c 24 78       	mov    QWORD PTR [rsp+0x78],rcx
ffffffffc0010b58:	48 8d 4c 24 08       	lea    rcx,[rsp+0x8]
ffffffffc0010b5d:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc0010b62:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
ffffffffc0010b67:	48 c7 44 24 20 a0 0b 	mov    QWORD PTR [rsp+0x20],0xffffffffc0010ba0
ffffffffc0010b6e:	01 c0 
ffffffffc0010b70:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x1
ffffffffc0010b77:	00 01 00 00 00 
ffffffffc0010b7c:	48 c7 44 24 10 a0 32 	mov    QWORD PTR [rsp+0x10],0xffffffffc00132a0
ffffffffc0010b83:	01 c0 
ffffffffc0010b85:	48 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],rcx
ffffffffc0010b8a:	48 c7 44 24 50 01 00 	mov    QWORD PTR [rsp+0x50],0x1
ffffffffc0010b91:	00 00 
ffffffffc0010b93:	e8 88 21 00 00       	call   ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>
ffffffffc0010b98:	e8 13 24 00 00       	call   ffffffffc0012fb0 <_ZN5amd648hlt_loop17hac4b60f2ae618ea8E>
ffffffffc0010b9d:	0f 0b                	ud2    
ffffffffc0010b9f:	cc                   	int3   

ffffffffc0010ba0 <_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17habecc554491087b3E>:
ffffffffc0010ba0:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
ffffffffc0010ba3:	e9 78 3d 00 00       	jmp    ffffffffc0014920 <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E>
ffffffffc0010ba8:	cc                   	int3   
ffffffffc0010ba9:	cc                   	int3   
ffffffffc0010baa:	cc                   	int3   
ffffffffc0010bab:	cc                   	int3   
ffffffffc0010bac:	cc                   	int3   
ffffffffc0010bad:	cc                   	int3   
ffffffffc0010bae:	cc                   	int3   
ffffffffc0010baf:	cc                   	int3   

ffffffffc0010bb0 <_ZN9libkernel4memm6talloc6Talloc14add_block_next17h9e604d16b4bcb140E.llvm.11767564005678988311>: ; rdi is Talloc, rsi is granularity
ffffffffc0010bb0:	sub    rsp,0x48                 ; drop the stack pointer down by 0x48
ffffffffc0010bb4:	mov    QWORD PTR [rsp],rsi      ; store rsi (granularity) on the stack at rsp
ffffffffc0010bb8:	cmp    rsi,0x3f                 ; check if the shift value is greater than 63
ffffffffc0010bbc:	ja     ffffffffc0010c20         ; panic on shift left with overflow
ffffffffc0010bbe:	mov    eax,0x1                  ; eax = 1
ffffffffc0010bc3:	shlx   rax,rax,rsi              ; shift 1 by rsi (granularity)
ffffffffc0010bc8:	or     QWORD PTR [rdi+0x20],rax ; self.avails |= 1 << granularity; (rax)
ffffffffc0010bcc:	cmp    QWORD PTR [rdi+0x30],rsi ; 
ffffffffc0010bd0:	jbe    ffffffffc0010c3a         ; bounds check llists access, trap at ud2 if out of bounds
ffffffffc0010bd2:	mov    rax,QWORD PTR [rdi+0x28]
ffffffffc0010bd6:	shl    rsi,0x4
ffffffffc0010bda:	mov    r8,QWORD PTR [rax+rsi*1] ; grab the [sentinel.next]
ffffffffc0010bde:	test   r8,r8
ffffffffc0010be1:	je     ffffffffc0010c3e         ; panic if its zero
ffffffffc0010be3:	add    rax,rsi                  ; else address sentinel in rax
ffffffffc0010be6:	mov    QWORD PTR [rcx],r8       ; set node.next to [sentinel.next]
ffffffffc0010be9:	mov    QWORD PTR [rcx+0x8],rax  ; set node.prev to sentinel
ffffffffc0010bed:	mov    QWORD PTR [r8+0x8],rcx   ; set [sentinel.next].prev to node
ffffffffc0010bf1:	mov    QWORD PTR [rax],rcx      ; set sentinel.next to node
ffffffffc0010bf4:	cmp    QWORD PTR [rcx],0x0      ; check if node.next is zero
ffffffffc0010bf8:	je     ffffffffc0010c7e         ; cri
ffffffffc0010bfe:	mov    rsi,rdx
ffffffffc0010c01:	shr    rsi,0x3
ffffffffc0010c05:	cmp    rsi,QWORD PTR [rdi+0x40]
ffffffffc0010c09:	jae    ffffffffc0010c3a         ; bounds check llists access, trap at ud2 if out of bounds
ffffffffc0010c0b:	and    dl,0x7
ffffffffc0010c0e:	mov    al,0x1
ffffffffc0010c10:	mov    ecx,edx
ffffffffc0010c12:	mov    rdx,QWORD PTR [rdi+0x38]
ffffffffc0010c16:	shl    al,cl
ffffffffc0010c18:	xor    BYTE PTR [rdx+rsi*1],al
ffffffffc0010c1b:	add    rsp,0x48
ffffffffc0010c1f:	ret    
; panic handlers
ffffffffc0010c20:	be 23 00 00 00       	mov    esi,0x23
ffffffffc0010c25:	48 c7 c7 f0 65 01 c0 	mov    rdi,0xffffffffc00165f0
ffffffffc0010c2c:	48 c7 c2 18 66 01 c0 	mov    rdx,0xffffffffc0016618
ffffffffc0010c33:	e8 f8 39 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0010c38:	0f 0b                	ud2    
ffffffffc0010c3a:	0f 0b                	ud2    
ffffffffc0010c3c:	0f 0b                	ud2    
ffffffffc0010c3e:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0010c43:	48 c7 c6 78 66 01 c0 	mov    rsi,0xffffffffc0016678
ffffffffc0010c4a:	48 c7 44 24 08 68 66 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016668
ffffffffc0010c51:	01 c0 
ffffffffc0010c53:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc0010c5a:	00 00 
ffffffffc0010c5c:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0010c63:	00 00 
ffffffffc0010c65:	48 c7 44 24 28 90 64 	mov    QWORD PTR [rsp+0x28],0xffffffffc0016490
ffffffffc0010c6c:	01 c0 
ffffffffc0010c6e:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc0010c75:	00 00 
ffffffffc0010c77:	e8 84 3a 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0010c7c:	0f 0b                	ud2    
ffffffffc0010c7e:	48 89 e0             	mov    rax,rsp
ffffffffc0010c81:	48 8d 4c 24 38       	lea    rcx,[rsp+0x38]
ffffffffc0010c86:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0010c8b:	48 c7 c6 48 66 01 c0 	mov    rsi,0xffffffffc0016648
ffffffffc0010c92:	48 c7 44 24 08 38 66 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016638
ffffffffc0010c99:	01 c0 
ffffffffc0010c9b:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc0010ca2:	00 00 
ffffffffc0010ca4:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0010cab:	00 00 
ffffffffc0010cad:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc0010cb2:	48 89 4c 24 28       	mov    QWORD PTR [rsp+0x28],rcx
ffffffffc0010cb7:	48 c7 44 24 40 10 54 	mov    QWORD PTR [rsp+0x40],0xffffffffc0015410
ffffffffc0010cbe:	01 c0 
ffffffffc0010cc0:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc0010cc7:	00 00 
ffffffffc0010cc9:	e8 32 3a 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0010cce:	0f 0b                	ud2    

ffffffffc0010cd0 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311>:
ffffffffc0010cd0:	55                   	push   rbp
ffffffffc0010cd1:	41 57                	push   r15
ffffffffc0010cd3:	41 56                	push   r14
ffffffffc0010cd5:	41 55                	push   r13
ffffffffc0010cd7:	41 54                	push   r12
ffffffffc0010cd9:	53                   	push   rbx
ffffffffc0010cda:	48 81 ec b8 00 00 00 	sub    rsp,0xb8
ffffffffc0010ce1:	48 39 77 30          	cmp    QWORD PTR [rdi+0x30],rsi
ffffffffc0010ce5:	0f 86 fa 04 00 00    	jbe    ffffffffc00111e5 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x515>
ffffffffc0010ceb:	48 89 f0             	mov    rax,rsi
ffffffffc0010cee:	48 8d 4c 24 48       	lea    rcx,[rsp+0x48]
ffffffffc0010cf3:	49 89 f4             	mov    r12,rsi
ffffffffc0010cf6:	48 89 94 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rdx
ffffffffc0010cfd:	00 
ffffffffc0010cfe:	48 8d 94 24 88 00 00 	lea    rdx,[rsp+0x88]
ffffffffc0010d05:	00 
ffffffffc0010d06:	49 89 ff             	mov    r15,rdi
ffffffffc0010d09:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0010d0e:	48 c7 44 24 58 b8 66 	mov    QWORD PTR [rsp+0x58],0xffffffffc00166b8
ffffffffc0010d15:	01 c0 
ffffffffc0010d17:	48 c7 44 24 60 01 00 	mov    QWORD PTR [rsp+0x60],0x1
ffffffffc0010d1e:	00 00 
ffffffffc0010d20:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc0010d27:	00 00 
ffffffffc0010d29:	48 c7 44 24 08 b8 95 	mov    QWORD PTR [rsp+0x8],0xffffffffc00195b8
ffffffffc0010d30:	01 c0 
ffffffffc0010d32:	48 c1 e0 04          	shl    rax,0x4
ffffffffc0010d36:	48 03 47 28          	add    rax,QWORD PTR [rdi+0x28]
ffffffffc0010d3a:	48 89 8c 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rcx
ffffffffc0010d41:	00 
ffffffffc0010d42:	48 8d 4c 24 58       	lea    rcx,[rsp+0x58]
ffffffffc0010d47:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0010d4e:	48 89 54 24 78       	mov    QWORD PTR [rsp+0x78],rdx
ffffffffc0010d53:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0xffffffffc0012d10
ffffffffc0010d5a:	00 10 2d 01 c0 
ffffffffc0010d5f:	49 89 d6             	mov    r14,rdx
ffffffffc0010d62:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x1
ffffffffc0010d69:	00 01 00 00 00 
ffffffffc0010d6e:	48 89 4c 24 38       	mov    QWORD PTR [rsp+0x38],rcx
ffffffffc0010d73:	49 89 cd             	mov    r13,rcx
ffffffffc0010d76:	48 c7 44 24 40 a0 32 	mov    QWORD PTR [rsp+0x40],0xffffffffc00132a0
ffffffffc0010d7d:	01 c0 
ffffffffc0010d7f:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
ffffffffc0010d84:	e8 67 15 00 00       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc0010d89:	48 89 c3             	mov    rbx,rax
ffffffffc0010d8c:	b1 01                	mov    cl,0x1
ffffffffc0010d8e:	66 90                	xchg   ax,ax
ffffffffc0010d90:	31 c0                	xor    eax,eax
ffffffffc0010d92:	f0 0f b0 0b          	lock cmpxchg BYTE PTR [rbx],cl
ffffffffc0010d96:	74 09                	je     ffffffffc0010da1 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0xd1>
ffffffffc0010d98:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
ffffffffc0010d9b:	84 c0                	test   al,al
ffffffffc0010d9d:	75 f9                	jne    ffffffffc0010d98 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0xc8>
ffffffffc0010d9f:	eb ef                	jmp    ffffffffc0010d90 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0xc0>
ffffffffc0010da1:	48 89 d8             	mov    rax,rbx
ffffffffc0010da4:	48 8d 6c 24 38       	lea    rbp,[rsp+0x38]
ffffffffc0010da9:	48 8d 7c 24 50       	lea    rdi,[rsp+0x50]
ffffffffc0010dae:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0010db3:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc0010dba:	48 c7 44 24 08 98 66 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016698
ffffffffc0010dc1:	01 c0 
ffffffffc0010dc3:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc0010dca:	00 00 
ffffffffc0010dcc:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0010dd3:	00 00 
ffffffffc0010dd5:	48 83 c0 02          	add    rax,0x2
ffffffffc0010dd9:	48 89 6c 24 28       	mov    QWORD PTR [rsp+0x28],rbp
ffffffffc0010dde:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc0010de5:	00 00 
ffffffffc0010de7:	48 89 44 24 50       	mov    QWORD PTR [rsp+0x50],rax
ffffffffc0010dec:	e8 0f 25 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0010df1:	c6 03 00             	mov    BYTE PTR [rbx],0x0
ffffffffc0010df4:	48 8b 4c 24 48       	mov    rcx,QWORD PTR [rsp+0x48]
ffffffffc0010df9:	48 8b 01             	mov    rax,QWORD PTR [rcx]
ffffffffc0010dfc:	48 39 41 08          	cmp    QWORD PTR [rcx+0x8],rax
ffffffffc0010e00:	75 1b                	jne    ffffffffc0010e1d <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x14d>
ffffffffc0010e02:	49 83 fc 3f          	cmp    r12,0x3f
ffffffffc0010e06:	0f 87 bf 03 00 00    	ja     ffffffffc00111cb <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x4fb>
ffffffffc0010e0c:	48 c7 c2 fe ff ff ff 	mov    rdx,0xfffffffffffffffe
ffffffffc0010e13:	44 89 e1             	mov    ecx,r12d
ffffffffc0010e16:	48 d3 c2             	rol    rdx,cl
ffffffffc0010e19:	49 21 57 20          	and    QWORD PTR [r15+0x20],rdx
ffffffffc0010e1d:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc0010e21:	48 89 e2             	mov    rdx,rsp
ffffffffc0010e24:	48 8d 8c 24 b0 00 00 	lea    rcx,[rsp+0xb0]
ffffffffc0010e2b:	00 
ffffffffc0010e2c:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0010e31:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0010e38:	48 8b 00             	mov    rax,QWORD PTR [rax]
ffffffffc0010e3b:	48 89 94 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rdx
ffffffffc0010e42:	00 
ffffffffc0010e43:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0xffffffffc0012d10
ffffffffc0010e4a:	00 10 2d 01 c0 
ffffffffc0010e4f:	48 89 8c 24 98 00 00 	mov    QWORD PTR [rsp+0x98],rcx
ffffffffc0010e56:	00 
ffffffffc0010e57:	48 c7 44 24 58 e8 66 	mov    QWORD PTR [rsp+0x58],0xffffffffc00166e8
ffffffffc0010e5e:	01 c0 
ffffffffc0010e60:	48 c7 44 24 60 02 00 	mov    QWORD PTR [rsp+0x60],0x2
ffffffffc0010e67:	00 00 
ffffffffc0010e69:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc0010e70:	00 00 
ffffffffc0010e72:	4c 89 74 24 78       	mov    QWORD PTR [rsp+0x78],r14
ffffffffc0010e77:	4c 89 6c 24 38       	mov    QWORD PTR [rsp+0x38],r13
ffffffffc0010e7c:	48 c7 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],0xffffffffc0012d10
ffffffffc0010e83:	00 10 2d 01 c0 
ffffffffc0010e88:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x2
ffffffffc0010e8f:	00 02 00 00 00 
ffffffffc0010e94:	48 c7 44 24 40 a0 32 	mov    QWORD PTR [rsp+0x40],0xffffffffc00132a0
ffffffffc0010e9b:	01 c0 
ffffffffc0010e9d:	48 c7 44 24 08 b8 95 	mov    QWORD PTR [rsp+0x8],0xffffffffc00195b8
ffffffffc0010ea4:	01 c0 
ffffffffc0010ea6:	48 89 84 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rax
ffffffffc0010ead:	00 
ffffffffc0010eae:	e8 3d 14 00 00       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc0010eb3:	48 89 c3             	mov    rbx,rax
ffffffffc0010eb6:	b1 01                	mov    cl,0x1
ffffffffc0010eb8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0010ebf:	00 
ffffffffc0010ec0:	31 c0                	xor    eax,eax
ffffffffc0010ec2:	f0 0f b0 0b          	lock cmpxchg BYTE PTR [rbx],cl
ffffffffc0010ec6:	74 09                	je     ffffffffc0010ed1 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x201>
ffffffffc0010ec8:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
ffffffffc0010ecb:	84 c0                	test   al,al
ffffffffc0010ecd:	75 f9                	jne    ffffffffc0010ec8 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x1f8>
ffffffffc0010ecf:	eb ef                	jmp    ffffffffc0010ec0 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x1f0>
ffffffffc0010ed1:	48 89 d8             	mov    rax,rbx
ffffffffc0010ed4:	48 8d 7c 24 50       	lea    rdi,[rsp+0x50]
ffffffffc0010ed9:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0010ede:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc0010ee5:	48 c7 44 24 08 98 66 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016698
ffffffffc0010eec:	01 c0 
ffffffffc0010eee:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc0010ef5:	00 00 
ffffffffc0010ef7:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0010efe:	00 00 
ffffffffc0010f00:	48 89 6c 24 28       	mov    QWORD PTR [rsp+0x28],rbp
ffffffffc0010f05:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc0010f0c:	00 00 
ffffffffc0010f0e:	48 83 c0 02          	add    rax,0x2
ffffffffc0010f12:	48 89 44 24 50       	mov    QWORD PTR [rsp+0x50],rax
ffffffffc0010f17:	e8 e4 23 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0010f1c:	c6 03 00             	mov    BYTE PTR [rbx],0x0
ffffffffc0010f1f:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc0010f23:	48 83 38 00          	cmp    QWORD PTR [rax],0x0
ffffffffc0010f27:	0f 85 c6 01 00 00    	jne    ffffffffc00110f3 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x423>
ffffffffc0010f2d:	48 8b 6c 24 48       	mov    rbp,QWORD PTR [rsp+0x48]
ffffffffc0010f32:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0010f39:	1f 84 00 00 00 00 00 
ffffffffc0010f40:	48 85 ed             	test   rbp,rbp
ffffffffc0010f43:	0f 94 c1             	sete   cl
ffffffffc0010f46:	74 0b                	je     ffffffffc0010f53 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x283>
ffffffffc0010f48:	48 39 c5             	cmp    rbp,rax
ffffffffc0010f4b:	74 06                	je     ffffffffc0010f53 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x283>
ffffffffc0010f4d:	48 8b 6d 08          	mov    rbp,QWORD PTR [rbp+0x8]
ffffffffc0010f51:	eb ed                	jmp    ffffffffc0010f40 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x270>
ffffffffc0010f53:	84 c9                	test   cl,cl
ffffffffc0010f55:	0f 84 c8 00 00 00    	je     ffffffffc0011023 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x353>
ffffffffc0010f5b:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0010f60:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0010f67:	48 c7 44 24 58 08 67 	mov    QWORD PTR [rsp+0x58],0xffffffffc0016708
ffffffffc0010f6e:	01 c0 
ffffffffc0010f70:	48 c7 44 24 60 01 00 	mov    QWORD PTR [rsp+0x60],0x1
ffffffffc0010f77:	00 00 
ffffffffc0010f79:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc0010f80:	00 00 
ffffffffc0010f82:	48 c7 44 24 78 90 64 	mov    QWORD PTR [rsp+0x78],0xffffffffc0016490
ffffffffc0010f89:	01 c0 
ffffffffc0010f8b:	4c 89 ac 24 88 00 00 	mov    QWORD PTR [rsp+0x88],r13
ffffffffc0010f92:	00 
ffffffffc0010f93:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x0
ffffffffc0010f9a:	00 00 00 00 00 
ffffffffc0010f9f:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0xffffffffc00132a0
ffffffffc0010fa6:	00 a0 32 01 c0 
ffffffffc0010fab:	48 c7 44 24 08 b8 95 	mov    QWORD PTR [rsp+0x8],0xffffffffc00195b8
ffffffffc0010fb2:	01 c0 
ffffffffc0010fb4:	e8 37 13 00 00       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc0010fb9:	48 89 c3             	mov    rbx,rax
ffffffffc0010fbc:	b1 01                	mov    cl,0x1
ffffffffc0010fbe:	66 90                	xchg   ax,ax
ffffffffc0010fc0:	31 c0                	xor    eax,eax
ffffffffc0010fc2:	f0 0f b0 0b          	lock cmpxchg BYTE PTR [rbx],cl
ffffffffc0010fc6:	74 09                	je     ffffffffc0010fd1 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x301>
ffffffffc0010fc8:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
ffffffffc0010fcb:	84 c0                	test   al,al
ffffffffc0010fcd:	75 f9                	jne    ffffffffc0010fc8 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x2f8>
ffffffffc0010fcf:	eb ef                	jmp    ffffffffc0010fc0 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x2f0>
ffffffffc0010fd1:	48 89 d8             	mov    rax,rbx
ffffffffc0010fd4:	48 8d 7c 24 38       	lea    rdi,[rsp+0x38]
ffffffffc0010fd9:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0010fde:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc0010fe5:	48 c7 44 24 08 98 66 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016698
ffffffffc0010fec:	01 c0 
ffffffffc0010fee:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc0010ff5:	00 00 
ffffffffc0010ff7:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0010ffe:	00 00 
ffffffffc0011000:	4c 89 74 24 28       	mov    QWORD PTR [rsp+0x28],r14
ffffffffc0011005:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc001100c:	00 00 
ffffffffc001100e:	48 83 c0 02          	add    rax,0x2
ffffffffc0011012:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc0011017:	e8 e4 22 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc001101c:	c6 03 00             	mov    BYTE PTR [rbx],0x0
ffffffffc001101f:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc0011023:	48 39 c5             	cmp    rbp,rax
ffffffffc0011026:	0f 85 c7 00 00 00    	jne    ffffffffc00110f3 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x423>
ffffffffc001102c:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0011031:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0011038:	48 c7 44 24 58 20 67 	mov    QWORD PTR [rsp+0x58],0xffffffffc0016720
ffffffffc001103f:	01 c0 
ffffffffc0011041:	48 c7 44 24 60 01 00 	mov    QWORD PTR [rsp+0x60],0x1
ffffffffc0011048:	00 00 
ffffffffc001104a:	48 c7 44 24 68 00 00 	mov    QWORD PTR [rsp+0x68],0x0
ffffffffc0011051:	00 00 
ffffffffc0011053:	48 c7 44 24 78 90 64 	mov    QWORD PTR [rsp+0x78],0xffffffffc0016490
ffffffffc001105a:	01 c0 
ffffffffc001105c:	4c 89 ac 24 88 00 00 	mov    QWORD PTR [rsp+0x88],r13
ffffffffc0011063:	00 
ffffffffc0011064:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x0
ffffffffc001106b:	00 00 00 00 00 
ffffffffc0011070:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0xffffffffc00132a0
ffffffffc0011077:	00 a0 32 01 c0 
ffffffffc001107c:	48 c7 44 24 08 b8 95 	mov    QWORD PTR [rsp+0x8],0xffffffffc00195b8
ffffffffc0011083:	01 c0 
ffffffffc0011085:	e8 66 12 00 00       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc001108a:	48 89 c3             	mov    rbx,rax
ffffffffc001108d:	b1 01                	mov    cl,0x1
ffffffffc001108f:	90                   	nop
ffffffffc0011090:	31 c0                	xor    eax,eax
ffffffffc0011092:	f0 0f b0 0b          	lock cmpxchg BYTE PTR [rbx],cl
ffffffffc0011096:	74 09                	je     ffffffffc00110a1 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x3d1>
ffffffffc0011098:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
ffffffffc001109b:	84 c0                	test   al,al
ffffffffc001109d:	75 f9                	jne    ffffffffc0011098 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x3c8>
ffffffffc001109f:	eb ef                	jmp    ffffffffc0011090 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x3c0>
ffffffffc00110a1:	48 89 d8             	mov    rax,rbx
ffffffffc00110a4:	48 8d 7c 24 38       	lea    rdi,[rsp+0x38]
ffffffffc00110a9:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc00110ae:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc00110b5:	48 c7 44 24 08 98 66 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016698
ffffffffc00110bc:	01 c0 
ffffffffc00110be:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc00110c5:	00 00 
ffffffffc00110c7:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc00110ce:	00 00 
ffffffffc00110d0:	4c 89 74 24 28       	mov    QWORD PTR [rsp+0x28],r14
ffffffffc00110d5:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc00110dc:	00 00 
ffffffffc00110de:	48 83 c0 02          	add    rax,0x2
ffffffffc00110e2:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc00110e7:	e8 14 22 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc00110ec:	c6 03 00             	mov    BYTE PTR [rbx],0x0
ffffffffc00110ef:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc00110f3:	48 8b 08             	mov    rcx,QWORD PTR [rax]
ffffffffc00110f6:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
ffffffffc00110fa:	48 89 0a             	mov    QWORD PTR [rdx],rcx
ffffffffc00110fd:	48 89 51 08          	mov    QWORD PTR [rcx+0x8],rdx
ffffffffc0011101:	48 8b 94 24 a8 00 00 	mov    rdx,QWORD PTR [rsp+0xa8]
ffffffffc0011108:	00 
ffffffffc0011109:	48 89 40 08          	mov    QWORD PTR [rax+0x8],rax
ffffffffc001110d:	48 89 00             	mov    QWORD PTR [rax],rax
ffffffffc0011110:	48 89 d1             	mov    rcx,rdx
ffffffffc0011113:	48 ff c9             	dec    rcx
ffffffffc0011116:	70 57                	jo     ffffffffc001116f <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x49f>
ffffffffc0011118:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc001111c:	c4 c2 f0 f2 0f       	andn   rcx,rcx,QWORD PTR [r15]
ffffffffc0011121:	48 29 c8             	sub    rax,rcx
ffffffffc0011124:	70 63                	jo     ffffffffc0011189 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x4b9>
ffffffffc0011126:	49 03 47 10          	add    rax,QWORD PTR [r15+0x10]
ffffffffc001112a:	72 77                	jb     ffffffffc00111a3 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x4d3>
ffffffffc001112c:	f3 48 0f bd ca       	lzcnt  rcx,rdx
ffffffffc0011131:	74 7e                	je     ffffffffc00111b1 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x4e1>
ffffffffc0011133:	f6 d9                	neg    cl
ffffffffc0011135:	c4 e2 f3 f7 c8       	shrx   rcx,rax,rcx
ffffffffc001113a:	48 89 c8             	mov    rax,rcx
ffffffffc001113d:	48 c1 e8 03          	shr    rax,0x3
ffffffffc0011141:	49 3b 47 40          	cmp    rax,QWORD PTR [r15+0x40]
ffffffffc0011145:	0f 83 9a 00 00 00    	jae    ffffffffc00111e5 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x515>
ffffffffc001114b:	49 8b 77 38          	mov    rsi,QWORD PTR [r15+0x38]
ffffffffc001114f:	b2 01                	mov    dl,0x1
ffffffffc0011151:	80 e1 07             	and    cl,0x7
ffffffffc0011154:	d2 e2                	shl    dl,cl
ffffffffc0011156:	30 14 06             	xor    BYTE PTR [rsi+rax*1],dl
ffffffffc0011159:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc001115d:	48 81 c4 b8 00 00 00 	add    rsp,0xb8
ffffffffc0011164:	5b                   	pop    rbx
ffffffffc0011165:	41 5c                	pop    r12
ffffffffc0011167:	41 5d                	pop    r13
ffffffffc0011169:	41 5e                	pop    r14
ffffffffc001116b:	41 5f                	pop    r15
ffffffffc001116d:	5d                   	pop    rbp
ffffffffc001116e:	c3                   	ret    
ffffffffc001116f:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011174:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc001117b:	48 c7 c2 a8 65 01 c0 	mov    rdx,0xffffffffc00165a8
ffffffffc0011182:	e8 a9 34 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011187:	0f 0b                	ud2    
ffffffffc0011189:	be 21 00 00 00       	mov    esi,0x21
ffffffffc001118e:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011195:	48 c7 c2 c0 65 01 c0 	mov    rdx,0xffffffffc00165c0
ffffffffc001119c:	e8 8f 34 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00111a1:	0f 0b                	ud2    
ffffffffc00111a3:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00111a8:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc00111af:	eb 0c                	jmp    ffffffffc00111bd <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311+0x4ed>
ffffffffc00111b1:	be 24 00 00 00       	mov    esi,0x24
ffffffffc00111b6:	48 c7 c7 50 65 01 c0 	mov    rdi,0xffffffffc0016550
ffffffffc00111bd:	48 c7 c2 d8 65 01 c0 	mov    rdx,0xffffffffc00165d8
ffffffffc00111c4:	e8 67 34 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00111c9:	0f 0b                	ud2    
ffffffffc00111cb:	be 23 00 00 00       	mov    esi,0x23
ffffffffc00111d0:	48 c7 c7 f0 65 01 c0 	mov    rdi,0xffffffffc00165f0
ffffffffc00111d7:	48 c7 c2 c8 66 01 c0 	mov    rdx,0xffffffffc00166c8
ffffffffc00111de:	e8 4d 34 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00111e3:	0f 0b                	ud2    
ffffffffc00111e5:	0f 0b                	ud2    
ffffffffc00111e7:	0f 0b                	ud2    
ffffffffc00111e9:	cc                   	int3   
ffffffffc00111ea:	cc                   	int3   
ffffffffc00111eb:	cc                   	int3   
ffffffffc00111ec:	cc                   	int3   
ffffffffc00111ed:	cc                   	int3   
ffffffffc00111ee:	cc                   	int3   
ffffffffc00111ef:	cc                   	int3   

ffffffffc00111f0 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE>:
ffffffffc00111f0:	48 83 ec 38          	sub    rsp,0x38
ffffffffc00111f4:	48 85 ff             	test   rdi,rdi
ffffffffc00111f7:	74 29                	je     ffffffffc0011222 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0x32>
ffffffffc00111f9:	48 b8 00 00 00 00 00 	movabs rax,0x1000000000000
ffffffffc0011200:	00 01 00 
ffffffffc0011203:	48 39 c7             	cmp    rdi,rax
ffffffffc0011206:	77 31                	ja     ffffffffc0011239 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0x49>
ffffffffc0011208:	48 85 f6             	test   rsi,rsi
ffffffffc001120b:	74 43                	je     ffffffffc0011250 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0x60>
ffffffffc001120d:	f3 48 0f b8 c6       	popcnt rax,rsi
ffffffffc0011212:	83 f8 01             	cmp    eax,0x1
ffffffffc0011215:	75 50                	jne    ffffffffc0011267 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0x77>
ffffffffc0011217:	48 83 fe 10          	cmp    rsi,0x10
ffffffffc001121b:	72 61                	jb     ffffffffc001127e <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0x8e>
ffffffffc001121d:	48 83 c4 38          	add    rsp,0x38
ffffffffc0011221:	c3                   	ret    
ffffffffc0011222:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0011227:	48 c7 c6 78 67 01 c0 	mov    rsi,0xffffffffc0016778
ffffffffc001122e:	48 c7 44 24 08 68 67 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016768
ffffffffc0011235:	01 c0 
ffffffffc0011237:	eb 5a                	jmp    ffffffffc0011293 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0xa3>
ffffffffc0011239:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc001123e:	48 c7 c6 d8 67 01 c0 	mov    rsi,0xffffffffc00167d8
ffffffffc0011245:	48 c7 44 24 08 c8 67 	mov    QWORD PTR [rsp+0x8],0xffffffffc00167c8
ffffffffc001124c:	01 c0 
ffffffffc001124e:	eb 43                	jmp    ffffffffc0011293 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0xa3>
ffffffffc0011250:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0011255:	48 c7 c6 20 68 01 c0 	mov    rsi,0xffffffffc0016820
ffffffffc001125c:	48 c7 44 24 08 10 68 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016810
ffffffffc0011263:	01 c0 
ffffffffc0011265:	eb 2c                	jmp    ffffffffc0011293 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0xa3>
ffffffffc0011267:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc001126c:	48 c7 c6 70 68 01 c0 	mov    rsi,0xffffffffc0016870
ffffffffc0011273:	48 c7 44 24 08 60 68 	mov    QWORD PTR [rsp+0x8],0xffffffffc0016860
ffffffffc001127a:	01 c0 
ffffffffc001127c:	eb 15                	jmp    ffffffffc0011293 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE+0xa3>
ffffffffc001127e:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0011283:	48 c7 c6 e0 68 01 c0 	mov    rsi,0xffffffffc00168e0
ffffffffc001128a:	48 c7 44 24 08 d0 68 	mov    QWORD PTR [rsp+0x8],0xffffffffc00168d0
ffffffffc0011291:	01 c0 
ffffffffc0011293:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc001129a:	00 00 
ffffffffc001129c:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc00112a3:	00 00 
ffffffffc00112a5:	48 c7 44 24 28 90 64 	mov    QWORD PTR [rsp+0x28],0xffffffffc0016490
ffffffffc00112ac:	01 c0 
ffffffffc00112ae:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc00112b5:	00 00 
ffffffffc00112b7:	e8 44 34 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc00112bc:	0f 0b                	ud2    
ffffffffc00112be:	cc                   	int3   
ffffffffc00112bf:	cc                   	int3   

ffffffffc00112c0 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E>:
ffffffffc00112c0:	41 56                	push   r14
ffffffffc00112c2:	53                   	push   rbx
ffffffffc00112c3:	48 83 ec 08          	sub    rsp,0x8
ffffffffc00112c7:	49 89 f6             	mov    r14,rsi
ffffffffc00112ca:	48 89 fb             	mov    rbx,rdi
ffffffffc00112cd:	e8 1e ff ff ff       	call   ffffffffc00111f0 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE>
ffffffffc00112d2:	48 83 eb 01          	sub    rbx,0x1
ffffffffc00112d6:	72 55                	jb     ffffffffc001132d <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0x6d>
ffffffffc00112d8:	0f 84 ab 00 00 00    	je     ffffffffc0011389 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0xc9>
ffffffffc00112de:	4d 85 f6             	test   r14,r14
ffffffffc00112e1:	0f 84 bc 00 00 00    	je     ffffffffc00113a3 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0xe3>
ffffffffc00112e7:	f3 48 0f bd cb       	lzcnt  rcx,rbx
ffffffffc00112ec:	b8 40 00 00 00       	mov    eax,0x40
ffffffffc00112f1:	29 c8                	sub    eax,ecx
ffffffffc00112f3:	f3 49 0f bd ce       	lzcnt  rcx,r14
ffffffffc00112f8:	83 f1 3f             	xor    ecx,0x3f
ffffffffc00112fb:	29 c8                	sub    eax,ecx
ffffffffc00112fd:	72 48                	jb     ffffffffc0011347 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0x87>
ffffffffc00112ff:	ff c0                	inc    eax
ffffffffc0011301:	74 52                	je     ffffffffc0011355 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0x95>
ffffffffc0011303:	83 f8 40             	cmp    eax,0x40
ffffffffc0011306:	73 67                	jae    ffffffffc001136f <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0xaf>
ffffffffc0011308:	89 c0                	mov    eax,eax
ffffffffc001130a:	be 01 00 00 00       	mov    esi,0x1
ffffffffc001130f:	89 c1                	mov    ecx,eax
ffffffffc0011311:	83 e1 3f             	and    ecx,0x3f
ffffffffc0011314:	c4 e2 f1 f7 d6       	shlx   rdx,rsi,rcx
ffffffffc0011319:	48 c1 ea 03          	shr    rdx,0x3
ffffffffc001131d:	48 83 f9 03          	cmp    rcx,0x3
ffffffffc0011321:	48 0f 42 d6          	cmovb  rdx,rsi
ffffffffc0011325:	48 83 c4 08          	add    rsp,0x8
ffffffffc0011329:	5b                   	pop    rbx
ffffffffc001132a:	41 5e                	pop    r14
ffffffffc001132c:	c3                   	ret    
ffffffffc001132d:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011332:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011339:	48 c7 c2 f8 68 01 c0 	mov    rdx,0xffffffffc00168f8
ffffffffc0011340:	e8 eb 32 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011345:	0f 0b                	ud2    
ffffffffc0011347:	be 21 00 00 00       	mov    esi,0x21
ffffffffc001134c:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011353:	eb 0c                	jmp    ffffffffc0011361 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E+0xa1>
ffffffffc0011355:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001135a:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc0011361:	48 c7 c2 28 69 01 c0 	mov    rdx,0xffffffffc0016928
ffffffffc0011368:	e8 c3 32 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001136d:	0f 0b                	ud2    
ffffffffc001136f:	be 23 00 00 00       	mov    esi,0x23
ffffffffc0011374:	48 c7 c7 f0 65 01 c0 	mov    rdi,0xffffffffc00165f0
ffffffffc001137b:	48 c7 c2 58 69 01 c0 	mov    rdx,0xffffffffc0016958
ffffffffc0011382:	e8 a9 32 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011387:	0f 0b                	ud2    
ffffffffc0011389:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001138e:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc0011395:	48 c7 c2 10 69 01 c0 	mov    rdx,0xffffffffc0016910
ffffffffc001139c:	e8 8f 32 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00113a1:	0f 0b                	ud2    
ffffffffc00113a3:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00113a8:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc00113af:	48 c7 c2 40 69 01 c0 	mov    rdx,0xffffffffc0016940
ffffffffc00113b6:	e8 75 32 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00113bb:	0f 0b                	ud2    
ffffffffc00113bd:	cc                   	int3   
ffffffffc00113be:	cc                   	int3   
ffffffffc00113bf:	cc                   	int3   

ffffffffc00113c0 <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE>:
ffffffffc00113c0:	55                   	push   rbp
ffffffffc00113c1:	41 57                	push   r15
ffffffffc00113c3:	41 56                	push   r14
ffffffffc00113c5:	41 55                	push   r13
ffffffffc00113c7:	41 54                	push   r12
ffffffffc00113c9:	53                   	push   rbx
ffffffffc00113ca:	48 83 ec 58          	sub    rsp,0x58
ffffffffc00113ce:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc00113d3:	48 89 fb             	mov    rbx,rdi
ffffffffc00113d6:	48 89 d7             	mov    rdi,rdx
ffffffffc00113d9:	48 89 ce             	mov    rsi,rcx
ffffffffc00113dc:	4d 89 ce             	mov    r14,r9
ffffffffc00113df:	4d 89 c7             	mov    r15,r8
ffffffffc00113e2:	49 89 cc             	mov    r12,rcx
ffffffffc00113e5:	49 89 d5             	mov    r13,rdx
ffffffffc00113e8:	e8 03 fe ff ff       	call   ffffffffc00111f0 <_ZN9libkernel4memm6talloc6Talloc19validate_arena_args17hfa28d17e40ab583eE>
ffffffffc00113ed:	4c 89 ef             	mov    rdi,r13
ffffffffc00113f0:	4c 89 e6             	mov    rsi,r12
ffffffffc00113f3:	e8 c8 fe ff ff       	call   ffffffffc00112c0 <_ZN9libkernel4memm6talloc6Talloc13slice_lengths17h5c66a58da59d5010E>
ffffffffc00113f8:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc00113fd:	48 89 54 24 20       	mov    QWORD PTR [rsp+0x20],rdx
ffffffffc0011402:	4c 89 74 24 08       	mov    QWORD PTR [rsp+0x8],r14
ffffffffc0011407:	4c 39 f0             	cmp    rax,r14
ffffffffc001140a:	0f 85 dc 00 00 00    	jne    ffffffffc00114ec <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0x12c>
ffffffffc0011410:	48 8b ac 24 98 00 00 	mov    rbp,QWORD PTR [rsp+0x98]
ffffffffc0011417:	00 
ffffffffc0011418:	48 89 6c 24 08       	mov    QWORD PTR [rsp+0x8],rbp
ffffffffc001141d:	48 39 ea             	cmp    rdx,rbp
ffffffffc0011420:	0f 85 e0 00 00 00    	jne    ffffffffc0011506 <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0x146>
ffffffffc0011426:	48 8b bc 24 90 00 00 	mov    rdi,QWORD PTR [rsp+0x90]
ffffffffc001142d:	00 
ffffffffc001142e:	48 85 ff             	test   rdi,rdi
ffffffffc0011431:	0f 84 f7 00 00 00    	je     ffffffffc001152e <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0x16e>
ffffffffc0011437:	31 f6                	xor    esi,esi
ffffffffc0011439:	48 89 ea             	mov    rdx,rbp
ffffffffc001143c:	e8 6f 4a 00 00       	call   ffffffffc0015eb0 <memset>
ffffffffc0011441:	4d 85 f6             	test   r14,r14
ffffffffc0011444:	74 1a                	je     ffffffffc0011460 <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0xa0>
ffffffffc0011446:	4c 89 f0             	mov    rax,r14
ffffffffc0011449:	4c 89 f9             	mov    rcx,r15
ffffffffc001144c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
ffffffffc0011450:	48 89 09             	mov    QWORD PTR [rcx],rcx
ffffffffc0011453:	48 89 49 08          	mov    QWORD PTR [rcx+0x8],rcx
ffffffffc0011457:	48 83 c1 10          	add    rcx,0x10
ffffffffc001145b:	48 ff c8             	dec    rax
ffffffffc001145e:	75 f0                	jne    ffffffffc0011450 <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0x90>
ffffffffc0011460:	49 8d 45 ff          	lea    rax,[r13-0x1]
ffffffffc0011464:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
ffffffffc001146b:	f3 48 0f bd c8       	lzcnt  rcx,rax
ffffffffc0011470:	31 c0                	xor    eax,eax
ffffffffc0011472:	49 83 fd 02          	cmp    r13,0x2
ffffffffc0011476:	c4 e2 f3 f7 ca       	shrx   rcx,rdx,rcx
ffffffffc001147b:	48 0f 43 c1          	cmovae rax,rcx
ffffffffc001147f:	48 ff c0             	inc    rax
ffffffffc0011482:	74 4e                	je     ffffffffc00114d2 <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0x112>
ffffffffc0011484:	48 8b 54 24 10       	mov    rdx,QWORD PTR [rsp+0x10]
ffffffffc0011489:	f3 48 0f bd c8       	lzcnt  rcx,rax
ffffffffc001148e:	48 89 13             	mov    QWORD PTR [rbx],rdx
ffffffffc0011491:	4c 89 6b 08          	mov    QWORD PTR [rbx+0x8],r13
ffffffffc0011495:	48 89 43 10          	mov    QWORD PTR [rbx+0x10],rax
ffffffffc0011499:	89 4b 48             	mov    DWORD PTR [rbx+0x48],ecx
ffffffffc001149c:	48 8b 8c 24 90 00 00 	mov    rcx,QWORD PTR [rsp+0x90]
ffffffffc00114a3:	00 
ffffffffc00114a4:	4c 89 63 18          	mov    QWORD PTR [rbx+0x18],r12
ffffffffc00114a8:	48 c7 43 20 00 00 00 	mov    QWORD PTR [rbx+0x20],0x0
ffffffffc00114af:	00 
ffffffffc00114b0:	4c 89 7b 28          	mov    QWORD PTR [rbx+0x28],r15
ffffffffc00114b4:	4c 89 73 30          	mov    QWORD PTR [rbx+0x30],r14
ffffffffc00114b8:	48 89 d8             	mov    rax,rbx
ffffffffc00114bb:	48 89 4b 38          	mov    QWORD PTR [rbx+0x38],rcx
ffffffffc00114bf:	48 89 6b 40          	mov    QWORD PTR [rbx+0x40],rbp
ffffffffc00114c3:	48 83 c4 58          	add    rsp,0x58
ffffffffc00114c7:	5b                   	pop    rbx
ffffffffc00114c8:	41 5c                	pop    r12
ffffffffc00114ca:	41 5d                	pop    r13
ffffffffc00114cc:	41 5e                	pop    r14
ffffffffc00114ce:	41 5f                	pop    r15
ffffffffc00114d0:	5d                   	pop    rbp
ffffffffc00114d1:	c3                   	ret    
ffffffffc00114d2:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00114d7:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc00114de:	48 c7 c2 00 65 01 c0 	mov    rdx,0xffffffffc0016500
ffffffffc00114e5:	e8 46 31 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00114ea:	0f 0b                	ud2    
ffffffffc00114ec:	48 8d 74 24 18       	lea    rsi,[rsp+0x18]
ffffffffc00114f1:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc00114f6:	48 8d 4c 24 28       	lea    rcx,[rsp+0x28]
ffffffffc00114fb:	31 ff                	xor    edi,edi
ffffffffc00114fd:	49 c7 c0 70 69 01 c0 	mov    r8,0xffffffffc0016970
ffffffffc0011504:	eb 18                	jmp    ffffffffc001151e <_ZN9libkernel4memm6talloc6Talloc3new17hbc8b8fd0e98c190fE+0x15e>
ffffffffc0011506:	48 8d 74 24 20       	lea    rsi,[rsp+0x20]
ffffffffc001150b:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0011510:	48 8d 4c 24 28       	lea    rcx,[rsp+0x28]
ffffffffc0011515:	31 ff                	xor    edi,edi
ffffffffc0011517:	49 c7 c0 88 69 01 c0 	mov    r8,0xffffffffc0016988
ffffffffc001151e:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
ffffffffc0011525:	00 00 
ffffffffc0011527:	e8 a4 18 00 00       	call   ffffffffc0012dd0 <_ZN4core9panicking13assert_failed17hee52879969419ac6E>
ffffffffc001152c:	0f 0b                	ud2    
ffffffffc001152e:	0f 0b                	ud2    
ffffffffc0011530:	0f 0b                	ud2    
ffffffffc0011532:	cc                   	int3   
ffffffffc0011533:	cc                   	int3   
ffffffffc0011534:	cc                   	int3   
ffffffffc0011535:	cc                   	int3   
ffffffffc0011536:	cc                   	int3   
ffffffffc0011537:	cc                   	int3   
ffffffffc0011538:	cc                   	int3   
ffffffffc0011539:	cc                   	int3   
ffffffffc001153a:	cc                   	int3   
ffffffffc001153b:	cc                   	int3   
ffffffffc001153c:	cc                   	int3   
ffffffffc001153d:	cc                   	int3   
ffffffffc001153e:	cc                   	int3   
ffffffffc001153f:	cc                   	int3   

ffffffffc0011540 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E>:
ffffffffc0011540:	55                   	push   rbp
ffffffffc0011541:	41 57                	push   r15
ffffffffc0011543:	41 56                	push   r14
ffffffffc0011545:	41 55                	push   r13
ffffffffc0011547:	41 54                	push   r12
ffffffffc0011549:	53                   	push   rbx
ffffffffc001154a:	48 83 ec 08          	sub    rsp,0x8
ffffffffc001154e:	48 39 d6             	cmp    rsi,rdx
ffffffffc0011551:	0f 84 69 01 00 00    	je     ffffffffc00116c0 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x180>
ffffffffc0011557:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc001155a:	49 89 fd             	mov    r13,rdi
ffffffffc001155d:	48 39 f0             	cmp    rax,rsi
ffffffffc0011560:	0f 8f 74 01 00 00    	jg     ffffffffc00116da <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x19a>
ffffffffc0011566:	49 03 45 08          	add    rax,QWORD PTR [r13+0x8]
ffffffffc001156a:	0f 80 1c 01 00 00    	jo     ffffffffc001168c <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x14c>
ffffffffc0011570:	49 89 d6             	mov    r14,rdx
ffffffffc0011573:	48 39 d0             	cmp    rax,rdx
ffffffffc0011576:	0f 8c 78 01 00 00    	jl     ffffffffc00116f4 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x1b4>
ffffffffc001157c:	49 8b 45 18          	mov    rax,QWORD PTR [r13+0x18]
ffffffffc0011580:	48 83 e8 01          	sub    rax,0x1
ffffffffc0011584:	0f 82 1c 01 00 00    	jb     ffffffffc00116a6 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x166>
ffffffffc001158a:	48 85 f0             	test   rax,rsi
ffffffffc001158d:	0f 85 7b 01 00 00    	jne    ffffffffc001170e <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x1ce>
ffffffffc0011593:	4c 85 f0             	test   rax,r14
ffffffffc0011596:	0f 85 8c 01 00 00    	jne    ffffffffc0011728 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x1e8>
ffffffffc001159c:	45 31 e4             	xor    r12d,r12d
ffffffffc001159f:	41 bf 01 00 00 00    	mov    r15d,0x1
ffffffffc00115a5:	66 66 2e 0f 1f 84 00 	data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc00115ac:	00 00 00 00 
ffffffffc00115b0:	41 f6 c4 01          	test   r12b,0x1
ffffffffc00115b4:	74 2a                	je     ffffffffc00115e0 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0xa0>
ffffffffc00115b6:	4c 89 f0             	mov    rax,r14
ffffffffc00115b9:	48 29 f0             	sub    rax,rsi
ffffffffc00115bc:	0f 80 7c 00 00 00    	jo     ffffffffc001163e <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0xfe>
ffffffffc00115c2:	49 3b 45 18          	cmp    rax,QWORD PTR [r13+0x18]
ffffffffc00115c6:	72 4d                	jb     ffffffffc0011615 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0xd5>
ffffffffc00115c8:	f3 48 0f bd c0       	lzcnt  rax,rax
ffffffffc00115cd:	48 89 f5             	mov    rbp,rsi
ffffffffc00115d0:	34 3f                	xor    al,0x3f
ffffffffc00115d2:	c4 c2 f9 f7 d7       	shlx   rdx,r15,rax
ffffffffc00115d7:	48 01 d5             	add    rbp,rdx
ffffffffc00115da:	0f 90 c3             	seto   bl
ffffffffc00115dd:	eb 1f                	jmp    ffffffffc00115fe <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0xbe>
ffffffffc00115df:	90                   	nop
ffffffffc00115e0:	f3 48 0f bc c6       	tzcnt  rax,rsi
ffffffffc00115e5:	a8 40                	test   al,0x40
ffffffffc00115e7:	75 6f                	jne    ffffffffc0011658 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x118>
ffffffffc00115e9:	c4 c2 f9 f7 d7       	shlx   rdx,r15,rax
ffffffffc00115ee:	48 89 f5             	mov    rbp,rsi
ffffffffc00115f1:	48 01 d5             	add    rbp,rdx
ffffffffc00115f4:	0f 90 c3             	seto   bl
ffffffffc00115f7:	70 79                	jo     ffffffffc0011672 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x132>
ffffffffc00115f9:	4c 39 f5             	cmp    rbp,r14
ffffffffc00115fc:	7f 12                	jg     ffffffffc0011610 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0xd0>
ffffffffc00115fe:	4c 89 ef             	mov    rdi,r13
ffffffffc0011601:	e8 da 02 00 00       	call   ffffffffc00118e0 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E>
ffffffffc0011606:	f6 c3 01             	test   bl,0x1
ffffffffc0011609:	75 19                	jne    ffffffffc0011624 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0xe4>
ffffffffc001160b:	48 89 ee             	mov    rsi,rbp
ffffffffc001160e:	eb a0                	jmp    ffffffffc00115b0 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x70>
ffffffffc0011610:	41 b4 01             	mov    r12b,0x1
ffffffffc0011613:	eb 9b                	jmp    ffffffffc00115b0 <_ZN9libkernel4memm6talloc6Talloc7release17he6fe50db6d494694E+0x70>
ffffffffc0011615:	48 83 c4 08          	add    rsp,0x8
ffffffffc0011619:	5b                   	pop    rbx
ffffffffc001161a:	41 5c                	pop    r12
ffffffffc001161c:	41 5d                	pop    r13
ffffffffc001161e:	41 5e                	pop    r14
ffffffffc0011620:	41 5f                	pop    r15
ffffffffc0011622:	5d                   	pop    rbp
ffffffffc0011623:	c3                   	ret    
ffffffffc0011624:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011629:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc0011630:	48 c7 c2 b8 6b 01 c0 	mov    rdx,0xffffffffc0016bb8
ffffffffc0011637:	e8 f4 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001163c:	0f 0b                	ud2    
ffffffffc001163e:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011643:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc001164a:	48 c7 c2 a0 6b 01 c0 	mov    rdx,0xffffffffc0016ba0
ffffffffc0011651:	e8 da 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011656:	0f 0b                	ud2    
ffffffffc0011658:	be 23 00 00 00       	mov    esi,0x23
ffffffffc001165d:	48 c7 c7 f0 65 01 c0 	mov    rdi,0xffffffffc00165f0
ffffffffc0011664:	48 c7 c2 70 6b 01 c0 	mov    rdx,0xffffffffc0016b70
ffffffffc001166b:	e8 c0 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011670:	0f 0b                	ud2    
ffffffffc0011672:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011677:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc001167e:	48 c7 c2 88 6b 01 c0 	mov    rdx,0xffffffffc0016b88
ffffffffc0011685:	e8 a6 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001168a:	0f 0b                	ud2    
ffffffffc001168c:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011691:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc0011698:	48 c7 c2 f8 6a 01 c0 	mov    rdx,0xffffffffc0016af8
ffffffffc001169f:	e8 8c 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00116a4:	0f 0b                	ud2    
ffffffffc00116a6:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00116ab:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc00116b2:	48 c7 c2 28 6b 01 c0 	mov    rdx,0xffffffffc0016b28
ffffffffc00116b9:	e8 72 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00116be:	0f 0b                	ud2    
ffffffffc00116c0:	be 28 00 00 00       	mov    esi,0x28
ffffffffc00116c5:	48 c7 c7 a0 69 01 c0 	mov    rdi,0xffffffffc00169a0
ffffffffc00116cc:	48 c7 c2 c8 6a 01 c0 	mov    rdx,0xffffffffc0016ac8
ffffffffc00116d3:	e8 58 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00116d8:	0f 0b                	ud2    
ffffffffc00116da:	be 2f 00 00 00       	mov    esi,0x2f
ffffffffc00116df:	48 c7 c7 c8 69 01 c0 	mov    rdi,0xffffffffc00169c8
ffffffffc00116e6:	48 c7 c2 e0 6a 01 c0 	mov    rdx,0xffffffffc0016ae0
ffffffffc00116ed:	e8 3e 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00116f2:	0f 0b                	ud2    
ffffffffc00116f4:	be 4a 00 00 00       	mov    esi,0x4a
ffffffffc00116f9:	48 c7 c7 f7 69 01 c0 	mov    rdi,0xffffffffc00169f7
ffffffffc0011700:	48 c7 c2 10 6b 01 c0 	mov    rdx,0xffffffffc0016b10
ffffffffc0011707:	e8 24 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001170c:	0f 0b                	ud2    
ffffffffc001170e:	be 41 00 00 00       	mov    esi,0x41
ffffffffc0011713:	48 c7 c7 41 6a 01 c0 	mov    rdi,0xffffffffc0016a41
ffffffffc001171a:	48 c7 c2 40 6b 01 c0 	mov    rdx,0xffffffffc0016b40
ffffffffc0011721:	e8 0a 2f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011726:	0f 0b                	ud2    
ffffffffc0011728:	be 3f 00 00 00       	mov    esi,0x3f
ffffffffc001172d:	48 c7 c7 82 6a 01 c0 	mov    rdi,0xffffffffc0016a82
ffffffffc0011734:	48 c7 c2 58 6b 01 c0 	mov    rdx,0xffffffffc0016b58
ffffffffc001173b:	e8 f0 2e 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011740:	0f 0b                	ud2    
ffffffffc0011742:	cc                   	int3   
ffffffffc0011743:	cc                   	int3   
ffffffffc0011744:	cc                   	int3   
ffffffffc0011745:	cc                   	int3   
ffffffffc0011746:	cc                   	int3   
ffffffffc0011747:	cc                   	int3   
ffffffffc0011748:	cc                   	int3   
ffffffffc0011749:	cc                   	int3   
ffffffffc001174a:	cc                   	int3   
ffffffffc001174b:	cc                   	int3   
ffffffffc001174c:	cc                   	int3   
ffffffffc001174d:	cc                   	int3   
ffffffffc001174e:	cc                   	int3   
ffffffffc001174f:	cc                   	int3   

ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>:
ffffffffc0011750:	55                   	push   rbp
ffffffffc0011751:	41 57                	push   r15
ffffffffc0011753:	41 56                	push   r14
ffffffffc0011755:	41 55                	push   r13
ffffffffc0011757:	41 54                	push   r12
ffffffffc0011759:	53                   	push   rbx
ffffffffc001175a:	48 83 ec 08          	sub    rsp,0x8
ffffffffc001175e:	f3 48 0f bd c6       	lzcnt  rax,rsi
ffffffffc0011763:	2b 47 48             	sub    eax,DWORD PTR [rdi+0x48]
ffffffffc0011766:	0f 82 37 01 00 00    	jb     ffffffffc00118a3 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x153>
ffffffffc001176c:	83 f8 3f             	cmp    eax,0x3f
ffffffffc001176f:	0f 87 48 01 00 00    	ja     ffffffffc00118bd <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x16d>
ffffffffc0011775:	41 89 c6             	mov    r14d,eax
ffffffffc0011778:	48 8b 47 20          	mov    rax,QWORD PTR [rdi+0x20]
ffffffffc001177c:	49 89 fd             	mov    r13,rdi
ffffffffc001177f:	44 89 f1             	mov    ecx,r14d
ffffffffc0011782:	83 e1 3f             	and    ecx,0x3f
ffffffffc0011785:	48 0f a3 c8          	bt     rax,rcx
ffffffffc0011789:	73 25                	jae    ffffffffc00117b0 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x60>
ffffffffc001178b:	48 89 f2             	mov    rdx,rsi
ffffffffc001178e:	4c 89 ef             	mov    rdi,r13
ffffffffc0011791:	4c 89 f6             	mov    rsi,r14
ffffffffc0011794:	e8 37 f5 ff ff       	call   ffffffffc0010cd0 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311>
ffffffffc0011799:	49 89 c7             	mov    r15,rax
ffffffffc001179c:	31 c0                	xor    eax,eax
ffffffffc001179e:	4c 89 fa             	mov    rdx,r15
ffffffffc00117a1:	48 83 c4 08          	add    rsp,0x8
ffffffffc00117a5:	5b                   	pop    rbx
ffffffffc00117a6:	41 5c                	pop    r12
ffffffffc00117a8:	41 5d                	pop    r13
ffffffffc00117aa:	41 5e                	pop    r14
ffffffffc00117ac:	41 5f                	pop    r15
ffffffffc00117ae:	5d                   	pop    rbp
ffffffffc00117af:	c3                   	ret    
ffffffffc00117b0:	48 c7 c2 ff ff ff ff 	mov    rdx,0xffffffffffffffff
ffffffffc00117b7:	c4 e2 f1 f7 ca       	shlx   rcx,rdx,rcx
ffffffffc00117bc:	c4 e2 f0 f2 c0       	andn   rax,rcx,rax
ffffffffc00117c1:	0f 84 90 00 00 00    	je     ffffffffc0011857 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x107>
ffffffffc00117c7:	f3 48 0f bd e8       	lzcnt  rbp,rax
ffffffffc00117cc:	4c 89 ef             	mov    rdi,r13
ffffffffc00117cf:	48 89 ee             	mov    rsi,rbp
ffffffffc00117d2:	48 83 f6 3f          	xor    rsi,0x3f
ffffffffc00117d6:	c4 c2 cb f7 5d 10    	shrx   rbx,QWORD PTR [r13+0x10],rsi
ffffffffc00117dc:	48 89 da             	mov    rdx,rbx
ffffffffc00117df:	e8 ec f4 ff ff       	call   ffffffffc0010cd0 <_ZN9libkernel4memm6talloc6Talloc17remove_block_next17h982b11eaafa30418E.llvm.11767564005678988311>
ffffffffc00117e4:	be 40 00 00 00       	mov    esi,0x40
ffffffffc00117e9:	49 89 c7             	mov    r15,rax
ffffffffc00117ec:	48 29 ee             	sub    rsi,rbp
ffffffffc00117ef:	4c 39 f6             	cmp    rsi,r14
ffffffffc00117f2:	77 a8                	ja     ffffffffc001179c <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x4c>
ffffffffc00117f4:	48 89 f5             	mov    rbp,rsi
ffffffffc00117f7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00117fe:	00 00 
ffffffffc0011800:	48 d1 eb             	shr    rbx,1
ffffffffc0011803:	4c 39 f6             	cmp    rsi,r14
ffffffffc0011806:	48 89 da             	mov    rdx,rbx
ffffffffc0011809:	41 0f 93 c4          	setae  r12b
ffffffffc001180d:	48 83 d5 00          	adc    rbp,0x0
ffffffffc0011811:	49 8d 0c 1f          	lea    rcx,[r15+rbx*1]
ffffffffc0011815:	48 f7 da             	neg    rdx
ffffffffc0011818:	49 23 55 00          	and    rdx,QWORD PTR [r13+0x0]
ffffffffc001181c:	48 89 c8             	mov    rax,rcx
ffffffffc001181f:	48 29 d0             	sub    rax,rdx
ffffffffc0011822:	70 3d                	jo     ffffffffc0011861 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x111>
ffffffffc0011824:	49 03 45 10          	add    rax,QWORD PTR [r13+0x10]
ffffffffc0011828:	72 51                	jb     ffffffffc001187b <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x12b>
ffffffffc001182a:	f3 48 0f bd d3       	lzcnt  rdx,rbx
ffffffffc001182f:	74 58                	je     ffffffffc0011889 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x139>
ffffffffc0011831:	f6 da                	neg    dl
ffffffffc0011833:	4c 89 ef             	mov    rdi,r13
ffffffffc0011836:	c4 e2 eb f7 d0       	shrx   rdx,rax,rdx
ffffffffc001183b:	e8 70 f3 ff ff       	call   ffffffffc0010bb0 <_ZN9libkernel4memm6talloc6Talloc14add_block_next17h9e604d16b4bcb140E.llvm.11767564005678988311>
ffffffffc0011840:	4c 39 f5             	cmp    rbp,r14
ffffffffc0011843:	48 89 ee             	mov    rsi,rbp
ffffffffc0011846:	0f 97 c0             	seta   al
ffffffffc0011849:	41 08 c4             	or     r12b,al
ffffffffc001184c:	41 80 fc 01          	cmp    r12b,0x1
ffffffffc0011850:	75 ae                	jne    ffffffffc0011800 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0xb0>
ffffffffc0011852:	e9 45 ff ff ff       	jmp    ffffffffc001179c <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x4c>
ffffffffc0011857:	b8 01 00 00 00       	mov    eax,0x1
ffffffffc001185c:	e9 3d ff ff ff       	jmp    ffffffffc001179e <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x4e>
ffffffffc0011861:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011866:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc001186d:	48 c7 c2 c0 65 01 c0 	mov    rdx,0xffffffffc00165c0
ffffffffc0011874:	e8 b7 2d 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011879:	0f 0b                	ud2    
ffffffffc001187b:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011880:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc0011887:	eb 0c                	jmp    ffffffffc0011895 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E+0x145>
ffffffffc0011889:	be 24 00 00 00       	mov    esi,0x24
ffffffffc001188e:	48 c7 c7 50 65 01 c0 	mov    rdi,0xffffffffc0016550
ffffffffc0011895:	48 c7 c2 d8 65 01 c0 	mov    rdx,0xffffffffc00165d8
ffffffffc001189c:	e8 8f 2d 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00118a1:	0f 0b                	ud2    
ffffffffc00118a3:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00118a8:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc00118af:	48 c7 c2 90 65 01 c0 	mov    rdx,0xffffffffc0016590
ffffffffc00118b6:	e8 75 2d 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00118bb:	0f 0b                	ud2    
ffffffffc00118bd:	be 23 00 00 00       	mov    esi,0x23
ffffffffc00118c2:	48 c7 c7 f0 65 01 c0 	mov    rdi,0xffffffffc00165f0
ffffffffc00118c9:	48 c7 c2 d0 6b 01 c0 	mov    rdx,0xffffffffc0016bd0
ffffffffc00118d0:	e8 5b 2d 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00118d5:	0f 0b                	ud2    
ffffffffc00118d7:	cc                   	int3   
ffffffffc00118d8:	cc                   	int3   
ffffffffc00118d9:	cc                   	int3   
ffffffffc00118da:	cc                   	int3   
ffffffffc00118db:	cc                   	int3   
ffffffffc00118dc:	cc                   	int3   
ffffffffc00118dd:	cc                   	int3   
ffffffffc00118de:	cc                   	int3   
ffffffffc00118df:	cc                   	int3   

ffffffffc00118e0 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E>:
ffffffffc00118e0:	55                   	push   rbp
ffffffffc00118e1:	41 57                	push   r15
ffffffffc00118e3:	41 56                	push   r14
ffffffffc00118e5:	41 55                	push   r13
ffffffffc00118e7:	41 54                	push   r12
ffffffffc00118e9:	53                   	push   rbx
ffffffffc00118ea:	48 83 ec 48          	sub    rsp,0x48
ffffffffc00118ee:	44 8b 4f 48          	mov    r9d,DWORD PTR [rdi+0x48]
ffffffffc00118f2:	f3 48 0f bd c2       	lzcnt  rax,rdx
ffffffffc00118f7:	49 89 f0             	mov    r8,rsi
ffffffffc00118fa:	89 c1                	mov    ecx,eax
ffffffffc00118fc:	44 29 c9             	sub    ecx,r9d
ffffffffc00118ff:	0f 82 13 02 00 00    	jb     ffffffffc0011b18 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x238>
ffffffffc0011905:	48 89 d6             	mov    rsi,rdx
ffffffffc0011908:	48 ff ce             	dec    rsi
ffffffffc001190b:	0f 80 77 01 00 00    	jo     ffffffffc0011a88 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1a8>
ffffffffc0011911:	48 8b 2f             	mov    rbp,QWORD PTR [rdi]
ffffffffc0011914:	48 89 6c 24 10       	mov    QWORD PTR [rsp+0x10],rbp
ffffffffc0011919:	c4 e2 c8 f2 ed       	andn   rbp,rsi,rbp
ffffffffc001191e:	4c 89 c6             	mov    rsi,r8
ffffffffc0011921:	48 29 ee             	sub    rsi,rbp
ffffffffc0011924:	0f 80 78 01 00 00    	jo     ffffffffc0011aa2 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1c2>
ffffffffc001192a:	4c 8b 57 10          	mov    r10,QWORD PTR [rdi+0x10]
ffffffffc001192e:	4c 01 d6             	add    rsi,r10
ffffffffc0011931:	0f 82 85 01 00 00    	jb     ffffffffc0011abc <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1dc>
ffffffffc0011937:	48 85 c0             	test   rax,rax
ffffffffc001193a:	0f 84 8a 01 00 00    	je     ffffffffc0011aca <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1ea>
ffffffffc0011940:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0011945:	4c 8b 5f 40          	mov    r11,QWORD PTR [rdi+0x40]
ffffffffc0011949:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
ffffffffc001194e:	f6 d8                	neg    al
ffffffffc0011950:	c4 62 fb f7 ee       	shrx   r13,rsi,rax
ffffffffc0011955:	4c 89 e8             	mov    rax,r13
ffffffffc0011958:	48 c1 e8 03          	shr    rax,0x3
ffffffffc001195c:	4c 39 d8             	cmp    rax,r11
ffffffffc001195f:	0f 83 e2 00 00 00    	jae    ffffffffc0011a47 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x167>
ffffffffc0011965:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
ffffffffc001196a:	41 89 cc             	mov    r12d,ecx
ffffffffc001196d:	4d 89 e7             	mov    r15,r12
ffffffffc0011970:	49 c1 e7 04          	shl    r15,0x4
ffffffffc0011974:	4c 8b 4e 38          	mov    r9,QWORD PTR [rsi+0x38]
ffffffffc0011978:	4c 8b 76 20          	mov    r14,QWORD PTR [rsi+0x20]
ffffffffc001197c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
ffffffffc0011980:	41 0f b6 34 01       	movzx  esi,BYTE PTR [r9+rax*1]
ffffffffc0011985:	44 89 e9             	mov    ecx,r13d
ffffffffc0011988:	b3 01                	mov    bl,0x1
ffffffffc001198a:	80 e1 07             	and    cl,0x7
ffffffffc001198d:	d2 e3                	shl    bl,cl
ffffffffc001198f:	0f b6 c9             	movzx  ecx,cl
ffffffffc0011992:	0f a3 ce             	bt     esi,ecx
ffffffffc0011995:	0f 83 b0 00 00 00    	jae    ffffffffc0011a4b <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x16b>
ffffffffc001199b:	4c 89 c1             	mov    rcx,r8
ffffffffc001199e:	49 8d 34 10          	lea    rsi,[r8+rdx*1]
ffffffffc00119a2:	48 29 d1             	sub    rcx,rdx
ffffffffc00119a5:	4c 85 c2             	test   rdx,r8
ffffffffc00119a8:	4c 0f 45 c1          	cmovne r8,rcx
ffffffffc00119ac:	48 0f 44 ce          	cmove  rcx,rsi
ffffffffc00119b0:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
ffffffffc00119b3:	48 8b 69 08          	mov    rbp,QWORD PTR [rcx+0x8]
ffffffffc00119b7:	48 39 f5             	cmp    rbp,rsi
ffffffffc00119ba:	75 1c                	jne    ffffffffc00119d8 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0xf8>
ffffffffc00119bc:	49 83 fc 3f          	cmp    r12,0x3f
ffffffffc00119c0:	0f 87 38 01 00 00    	ja     ffffffffc0011afe <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x21e>
ffffffffc00119c6:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc00119cb:	4d 0f b3 e6          	btr    r14,r12
ffffffffc00119cf:	4c 89 77 20          	mov    QWORD PTR [rdi+0x20],r14
ffffffffc00119d3:	48 8b 7c 24 10       	mov    rdi,QWORD PTR [rsp+0x10]
ffffffffc00119d8:	48 89 75 00          	mov    QWORD PTR [rbp+0x0],rsi
ffffffffc00119dc:	48 89 6e 08          	mov    QWORD PTR [rsi+0x8],rbp
ffffffffc00119e0:	48 89 49 08          	mov    QWORD PTR [rcx+0x8],rcx
ffffffffc00119e4:	48 89 09             	mov    QWORD PTR [rcx],rcx
ffffffffc00119e7:	41 30 1c 01          	xor    BYTE PTR [r9+rax*1],bl
ffffffffc00119eb:	49 83 fc 01          	cmp    r12,0x1
ffffffffc00119ef:	0f 82 ef 00 00 00    	jb     ffffffffc0011ae4 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x204>
ffffffffc00119f5:	48 01 d2             	add    rdx,rdx
ffffffffc00119f8:	48 89 d0             	mov    rax,rdx
ffffffffc00119fb:	48 ff c8             	dec    rax
ffffffffc00119fe:	0f 80 84 00 00 00    	jo     ffffffffc0011a88 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1a8>
ffffffffc0011a04:	c4 e2 f8 f2 cf       	andn   rcx,rax,rdi
ffffffffc0011a09:	4c 89 c0             	mov    rax,r8
ffffffffc0011a0c:	48 29 c8             	sub    rax,rcx
ffffffffc0011a0f:	0f 80 8d 00 00 00    	jo     ffffffffc0011aa2 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1c2>
ffffffffc0011a15:	4c 01 d0             	add    rax,r10
ffffffffc0011a18:	0f 82 9e 00 00 00    	jb     ffffffffc0011abc <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1dc>
ffffffffc0011a1e:	f3 48 0f bd ca       	lzcnt  rcx,rdx
ffffffffc0011a23:	0f 84 a1 00 00 00    	je     ffffffffc0011aca <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1ea>
ffffffffc0011a29:	f6 d9                	neg    cl
ffffffffc0011a2b:	49 83 c7 f0          	add    r15,0xfffffffffffffff0
ffffffffc0011a2f:	49 ff cc             	dec    r12
ffffffffc0011a32:	c4 62 f3 f7 e8       	shrx   r13,rax,rcx
ffffffffc0011a37:	4c 89 e8             	mov    rax,r13
ffffffffc0011a3a:	48 c1 e8 03          	shr    rax,0x3
ffffffffc0011a3e:	4c 39 d8             	cmp    rax,r11
ffffffffc0011a41:	0f 82 39 ff ff ff    	jb     ffffffffc0011980 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0xa0>
ffffffffc0011a47:	0f 0b                	ud2    
ffffffffc0011a49:	0f 0b                	ud2    
ffffffffc0011a4b:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
ffffffffc0011a50:	4c 89 e6             	mov    rsi,r12
ffffffffc0011a53:	4c 89 ea             	mov    rdx,r13
ffffffffc0011a56:	4c 89 c1             	mov    rcx,r8
ffffffffc0011a59:	48 89 df             	mov    rdi,rbx
ffffffffc0011a5c:	e8 4f f1 ff ff       	call   ffffffffc0010bb0 <_ZN9libkernel4memm6talloc6Talloc14add_block_next17h9e604d16b4bcb140E.llvm.11767564005678988311>
ffffffffc0011a61:	4c 3b 63 30          	cmp    r12,QWORD PTR [rbx+0x30]
ffffffffc0011a65:	73 e0                	jae    ffffffffc0011a47 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x167>
ffffffffc0011a67:	48 8b 43 28          	mov    rax,QWORD PTR [rbx+0x28]
ffffffffc0011a6b:	4a 8b 04 38          	mov    rax,QWORD PTR [rax+r15*1]
ffffffffc0011a6f:	48 83 38 00          	cmp    QWORD PTR [rax],0x0
ffffffffc0011a73:	0f 84 b9 00 00 00    	je     ffffffffc0011b32 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x252>
ffffffffc0011a79:	48 83 c4 48          	add    rsp,0x48
ffffffffc0011a7d:	5b                   	pop    rbx
ffffffffc0011a7e:	41 5c                	pop    r12
ffffffffc0011a80:	41 5d                	pop    r13
ffffffffc0011a82:	41 5e                	pop    r14
ffffffffc0011a84:	41 5f                	pop    r15
ffffffffc0011a86:	5d                   	pop    rbp
ffffffffc0011a87:	c3                   	ret    
ffffffffc0011a88:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011a8d:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011a94:	48 c7 c2 a8 65 01 c0 	mov    rdx,0xffffffffc00165a8
ffffffffc0011a9b:	e8 90 2b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011aa0:	0f 0b                	ud2    
ffffffffc0011aa2:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011aa7:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011aae:	48 c7 c2 c0 65 01 c0 	mov    rdx,0xffffffffc00165c0
ffffffffc0011ab5:	e8 76 2b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011aba:	0f 0b                	ud2    
ffffffffc0011abc:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011ac1:	48 c7 c7 70 64 01 c0 	mov    rdi,0xffffffffc0016470
ffffffffc0011ac8:	eb 0c                	jmp    ffffffffc0011ad6 <_ZN9libkernel4memm6talloc6Talloc7dealloc17hbf75574fdbbfb8d1E+0x1f6>
ffffffffc0011aca:	be 24 00 00 00       	mov    esi,0x24
ffffffffc0011acf:	48 c7 c7 50 65 01 c0 	mov    rdi,0xffffffffc0016550
ffffffffc0011ad6:	48 c7 c2 d8 65 01 c0 	mov    rdx,0xffffffffc00165d8
ffffffffc0011add:	e8 4e 2b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011ae2:	0f 0b                	ud2    
ffffffffc0011ae4:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011ae9:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011af0:	48 c7 c2 e8 6b 01 c0 	mov    rdx,0xffffffffc0016be8
ffffffffc0011af7:	e8 34 2b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011afc:	0f 0b                	ud2    
ffffffffc0011afe:	be 23 00 00 00       	mov    esi,0x23
ffffffffc0011b03:	48 c7 c7 f0 65 01 c0 	mov    rdi,0xffffffffc00165f0
ffffffffc0011b0a:	48 c7 c2 30 67 01 c0 	mov    rdx,0xffffffffc0016730
ffffffffc0011b11:	e8 1a 2b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011b16:	0f 0b                	ud2    
ffffffffc0011b18:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0011b1d:	48 c7 c7 20 65 01 c0 	mov    rdi,0xffffffffc0016520
ffffffffc0011b24:	48 c7 c2 90 65 01 c0 	mov    rdx,0xffffffffc0016590
ffffffffc0011b2b:	e8 00 2b 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011b30:	0f 0b                	ud2    
ffffffffc0011b32:	48 8d 7c 24 18       	lea    rdi,[rsp+0x18]
ffffffffc0011b37:	48 c7 c6 18 6c 01 c0 	mov    rsi,0xffffffffc0016c18
ffffffffc0011b3e:	48 c7 44 24 18 08 6c 	mov    QWORD PTR [rsp+0x18],0xffffffffc0016c08
ffffffffc0011b45:	01 c0 
ffffffffc0011b47:	48 c7 44 24 20 01 00 	mov    QWORD PTR [rsp+0x20],0x1
ffffffffc0011b4e:	00 00 
ffffffffc0011b50:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
ffffffffc0011b57:	00 00 
ffffffffc0011b59:	48 c7 44 24 38 90 64 	mov    QWORD PTR [rsp+0x38],0xffffffffc0016490
ffffffffc0011b60:	01 c0 
ffffffffc0011b62:	48 c7 44 24 40 00 00 	mov    QWORD PTR [rsp+0x40],0x0
ffffffffc0011b69:	00 00 
ffffffffc0011b6b:	e8 90 2b 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0011b70:	0f 0b                	ud2    
ffffffffc0011b72:	cc                   	int3   
ffffffffc0011b73:	cc                   	int3   
ffffffffc0011b74:	cc                   	int3   
ffffffffc0011b75:	cc                   	int3   
ffffffffc0011b76:	cc                   	int3   
ffffffffc0011b77:	cc                   	int3   
ffffffffc0011b78:	cc                   	int3   
ffffffffc0011b79:	cc                   	int3   
ffffffffc0011b7a:	cc                   	int3   
ffffffffc0011b7b:	cc                   	int3   
ffffffffc0011b7c:	cc                   	int3   
ffffffffc0011b7d:	cc                   	int3   
ffffffffc0011b7e:	cc                   	int3   
ffffffffc0011b7f:	cc                   	int3   

ffffffffc0011b80 <_ZN4core3ops8function6FnOnce9call_once17h91a2076dde32e0e1E>:
ffffffffc0011b80:	53                   	push   rbx
ffffffffc0011b81:	48 81 ec a0 00 00 00 	sub    rsp,0xa0
ffffffffc0011b88:	48 89 fb             	mov    rbx,rdi
ffffffffc0011b8b:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc0011b90:	be f8 03 00 00       	mov    esi,0x3f8
ffffffffc0011b95:	e8 36 01 00 00       	call   ffffffffc0011cd0 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E>
ffffffffc0011b9a:	66 83 7c 24 08 00    	cmp    WORD PTR [rsp+0x8],0x0
ffffffffc0011ba0:	0f 85 db 00 00 00    	jne    ffffffffc0011c81 <_ZN4core3ops8function6FnOnce9call_once17h91a2076dde32e0e1E+0x101>
ffffffffc0011ba6:	4c 8b 44 24 32       	mov    r8,QWORD PTR [rsp+0x32]
ffffffffc0011bab:	48 8b 4c 24 2a       	mov    rcx,QWORD PTR [rsp+0x2a]
ffffffffc0011bb0:	48 8b 54 24 22       	mov    rdx,QWORD PTR [rsp+0x22]
ffffffffc0011bb5:	48 8b 74 24 1a       	mov    rsi,QWORD PTR [rsp+0x1a]
ffffffffc0011bba:	48 8b 7c 24 0a       	mov    rdi,QWORD PTR [rsp+0xa]
ffffffffc0011bbf:	48 8b 44 24 12       	mov    rax,QWORD PTR [rsp+0x12]
ffffffffc0011bc4:	44 0f b7 4c 24 3a    	movzx  r9d,WORD PTR [rsp+0x3a]
ffffffffc0011bca:	4c 89 44 24 31       	mov    QWORD PTR [rsp+0x31],r8
ffffffffc0011bcf:	48 89 4c 24 29       	mov    QWORD PTR [rsp+0x29],rcx
ffffffffc0011bd4:	48 89 54 24 21       	mov    QWORD PTR [rsp+0x21],rdx
ffffffffc0011bd9:	48 89 74 24 19       	mov    QWORD PTR [rsp+0x19],rsi
ffffffffc0011bde:	48 89 44 24 11       	mov    QWORD PTR [rsp+0x11],rax
ffffffffc0011be3:	48 89 7c 24 09       	mov    QWORD PTR [rsp+0x9],rdi
ffffffffc0011be8:	48 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],rcx
ffffffffc0011bed:	48 89 8c 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rcx
ffffffffc0011bf4:	00 
ffffffffc0011bf5:	48 89 54 24 58       	mov    QWORD PTR [rsp+0x58],rdx
ffffffffc0011bfa:	48 89 94 24 88 00 00 	mov    QWORD PTR [rsp+0x88],rdx
ffffffffc0011c01:	00 
ffffffffc0011c02:	48 89 44 24 48       	mov    QWORD PTR [rsp+0x48],rax
ffffffffc0011c07:	48 89 44 24 78       	mov    QWORD PTR [rsp+0x78],rax
ffffffffc0011c0c:	4c 89 44 24 68       	mov    QWORD PTR [rsp+0x68],r8
ffffffffc0011c11:	48 89 74 24 50       	mov    QWORD PTR [rsp+0x50],rsi
ffffffffc0011c16:	48 89 7c 24 40       	mov    QWORD PTR [rsp+0x40],rdi
ffffffffc0011c1b:	4c 89 84 24 98 00 00 	mov    QWORD PTR [rsp+0x98],r8
ffffffffc0011c22:	00 
ffffffffc0011c23:	48 89 b4 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rsi
ffffffffc0011c2a:	00 
ffffffffc0011c2b:	48 89 7c 24 70       	mov    QWORD PTR [rsp+0x70],rdi
ffffffffc0011c30:	48 8b 54 24 30       	mov    rdx,QWORD PTR [rsp+0x30]
ffffffffc0011c35:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
ffffffffc0011c3a:	8a 44 24 38          	mov    al,BYTE PTR [rsp+0x38]
ffffffffc0011c3e:	48 89 53 29          	mov    QWORD PTR [rbx+0x29],rdx
ffffffffc0011c42:	48 89 4b 21          	mov    QWORD PTR [rbx+0x21],rcx
ffffffffc0011c46:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
ffffffffc0011c4b:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
ffffffffc0011c50:	88 43 31             	mov    BYTE PTR [rbx+0x31],al
ffffffffc0011c53:	48 89 d8             	mov    rax,rbx
ffffffffc0011c56:	48 89 53 19          	mov    QWORD PTR [rbx+0x19],rdx
ffffffffc0011c5a:	48 89 4b 11          	mov    QWORD PTR [rbx+0x11],rcx
ffffffffc0011c5e:	48 8b 54 24 10       	mov    rdx,QWORD PTR [rsp+0x10]
ffffffffc0011c63:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
ffffffffc0011c68:	48 89 53 09          	mov    QWORD PTR [rbx+0x9],rdx
ffffffffc0011c6c:	48 89 4b 01          	mov    QWORD PTR [rbx+0x1],rcx
ffffffffc0011c70:	c6 03 00             	mov    BYTE PTR [rbx],0x0
ffffffffc0011c73:	66 44 89 4b 32       	mov    WORD PTR [rbx+0x32],r9w
ffffffffc0011c78:	48 81 c4 a0 00 00 00 	add    rsp,0xa0
ffffffffc0011c7f:	5b                   	pop    rbx
ffffffffc0011c80:	c3                   	ret    
ffffffffc0011c81:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
ffffffffc0011c86:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
ffffffffc0011c8b:	48 8d 54 24 40       	lea    rdx,[rsp+0x40]
ffffffffc0011c90:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0011c95:	48 c7 c7 70 6c 01 c0 	mov    rdi,0xffffffffc0016c70
ffffffffc0011c9c:	49 c7 c0 08 6d 01 c0 	mov    r8,0xffffffffc0016d08
ffffffffc0011ca3:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
ffffffffc0011ca8:	48 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],rcx
ffffffffc0011cad:	48 c7 c1 30 6c 01 c0 	mov    rcx,0xffffffffc0016c30
ffffffffc0011cb4:	e8 c7 31 00 00       	call   ffffffffc0014e80 <_ZN4core6result13unwrap_failed17he47b8d70f74ecda1E>
ffffffffc0011cb9:	0f 0b                	ud2    
ffffffffc0011cbb:	cc                   	int3   
ffffffffc0011cbc:	cc                   	int3   
ffffffffc0011cbd:	cc                   	int3   
ffffffffc0011cbe:	cc                   	int3   
ffffffffc0011cbf:	cc                   	int3   

ffffffffc0011cc0 <_ZN4core3ptr28drop_in_place$LT$$RF$str$GT$17h4c2abc1b4f2e920bE>:
ffffffffc0011cc0:	c3                   	ret    
ffffffffc0011cc1:	cc                   	int3   
ffffffffc0011cc2:	cc                   	int3   
ffffffffc0011cc3:	cc                   	int3   
ffffffffc0011cc4:	cc                   	int3   
ffffffffc0011cc5:	cc                   	int3   
ffffffffc0011cc6:	cc                   	int3   
ffffffffc0011cc7:	cc                   	int3   
ffffffffc0011cc8:	cc                   	int3   
ffffffffc0011cc9:	cc                   	int3   
ffffffffc0011cca:	cc                   	int3   
ffffffffc0011ccb:	cc                   	int3   
ffffffffc0011ccc:	cc                   	int3   
ffffffffc0011ccd:	cc                   	int3   
ffffffffc0011cce:	cc                   	int3   
ffffffffc0011ccf:	cc                   	int3   

ffffffffc0011cd0 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E>:
ffffffffc0011cd0:	55                   	push   rbp
ffffffffc0011cd1:	41 57                	push   r15
ffffffffc0011cd3:	41 56                	push   r14
ffffffffc0011cd5:	41 55                	push   r13
ffffffffc0011cd7:	41 54                	push   r12
ffffffffc0011cd9:	53                   	push   rbx
ffffffffc0011cda:	48 83 ec 28          	sub    rsp,0x28
ffffffffc0011cde:	41 89 f5             	mov    r13d,esi
ffffffffc0011ce1:	44 89 eb             	mov    ebx,r13d
ffffffffc0011ce4:	66 83 c3 02          	add    bx,0x2
ffffffffc0011ce8:	0f 82 9f 02 00 00    	jb     ffffffffc0011f8d <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x2bd>
ffffffffc0011cee:	49 89 fc             	mov    r12,rdi
ffffffffc0011cf1:	89 df                	mov    edi,ebx
ffffffffc0011cf3:	be e7 00 00 00       	mov    esi,0xe7
ffffffffc0011cf8:	e8 f3 11 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011cfd:	89 df                	mov    edi,ebx
ffffffffc0011cff:	e8 fc 11 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0011d04:	a8 40                	test   al,0x40
ffffffffc0011d06:	75 3c                	jne    ffffffffc0011d44 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x74>
ffffffffc0011d08:	44 89 ed             	mov    ebp,r13d
ffffffffc0011d0b:	66 83 c5 07          	add    bp,0x7
ffffffffc0011d0f:	0f 82 14 03 00 00    	jb     ffffffffc0012029 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x359>
ffffffffc0011d15:	89 ef                	mov    edi,ebp
ffffffffc0011d17:	be 2a 00 00 00       	mov    esi,0x2a
ffffffffc0011d1c:	e8 cf 11 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011d21:	89 ef                	mov    edi,ebp
ffffffffc0011d23:	e8 d8 11 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0011d28:	3c 2a                	cmp    al,0x2a
ffffffffc0011d2a:	b8 42 40 00 00       	mov    eax,0x4042
ffffffffc0011d2f:	b9 3a 20 00 00       	mov    ecx,0x203a
ffffffffc0011d34:	41 b0 1f             	mov    r8b,0x1f
ffffffffc0011d37:	41 b2 cf             	mov    r10b,0xcf
ffffffffc0011d3a:	b2 0f                	mov    dl,0xf
ffffffffc0011d3c:	0f 44 c8             	cmove  ecx,eax
ffffffffc0011d3f:	45 31 c9             	xor    r9d,r9d
ffffffffc0011d42:	eb 2c                	jmp    ffffffffc0011d70 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0xa0>
ffffffffc0011d44:	41 b0 1f             	mov    r8b,0x1f
ffffffffc0011d47:	41 b2 cf             	mov    r10b,0xcf
ffffffffc0011d4a:	b2 0f                	mov    dl,0xf
ffffffffc0011d4c:	84 c0                	test   al,al
ffffffffc0011d4e:	78 09                	js     ffffffffc0011d59 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x89>
ffffffffc0011d50:	66 b9 a6 40          	mov    cx,0x40a6
ffffffffc0011d54:	45 31 c9             	xor    r9d,r9d
ffffffffc0011d57:	eb 17                	jmp    ffffffffc0011d70 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0xa0>
ffffffffc0011d59:	66 b9 a7 40          	mov    cx,0x40a7
ffffffffc0011d5d:	41 b1 e7             	mov    r9b,0xe7
ffffffffc0011d60:	a8 20                	test   al,0x20
ffffffffc0011d62:	74 0c                	je     ffffffffc0011d70 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0xa0>
ffffffffc0011d64:	41 b2 ef             	mov    r10b,0xef
ffffffffc0011d67:	66 b9 6e 41          	mov    cx,0x416e
ffffffffc0011d6b:	b2 3f                	mov    dl,0x3f
ffffffffc0011d6d:	41 b0 3f             	mov    r8b,0x3f
ffffffffc0011d70:	45 89 ef             	mov    r15d,r13d
ffffffffc0011d73:	66 41 83 c7 03       	add    r15w,0x3
ffffffffc0011d78:	0f 82 29 02 00 00    	jb     ffffffffc0011fa7 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x2d7>
ffffffffc0011d7e:	44 89 ed             	mov    ebp,r13d
ffffffffc0011d81:	66 83 c5 04          	add    bp,0x4
ffffffffc0011d85:	0f 82 36 02 00 00    	jb     ffffffffc0011fc1 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x2f1>
ffffffffc0011d8b:	44 89 e8             	mov    eax,r13d
ffffffffc0011d8e:	66 83 c0 05          	add    ax,0x5
ffffffffc0011d92:	0f 82 43 02 00 00    	jb     ffffffffc0011fdb <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x30b>
ffffffffc0011d98:	44 89 ef             	mov    edi,r13d
ffffffffc0011d9b:	66 83 c7 06          	add    di,0x6
ffffffffc0011d9f:	0f 82 50 02 00 00    	jb     ffffffffc0011ff5 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x325>
ffffffffc0011da5:	44 89 ee             	mov    esi,r13d
ffffffffc0011da8:	66 83 c6 07          	add    si,0x7
ffffffffc0011dac:	0f 82 5d 02 00 00    	jb     ffffffffc001200f <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x33f>
ffffffffc0011db2:	45 8d 75 01          	lea    r14d,[r13+0x1]
ffffffffc0011db6:	66 89 74 24 0e       	mov    WORD PTR [rsp+0xe],si
ffffffffc0011dbb:	66 89 7c 24 10       	mov    WORD PTR [rsp+0x10],di
ffffffffc0011dc0:	31 f6                	xor    esi,esi
ffffffffc0011dc2:	89 6c 24 24          	mov    DWORD PTR [rsp+0x24],ebp
ffffffffc0011dc6:	66 89 44 24 12       	mov    WORD PTR [rsp+0x12],ax
ffffffffc0011dcb:	88 54 24 0c          	mov    BYTE PTR [rsp+0xc],dl
ffffffffc0011dcf:	44 88 54 24 0d       	mov    BYTE PTR [rsp+0xd],r10b
ffffffffc0011dd4:	89 4c 24 1c          	mov    DWORD PTR [rsp+0x1c],ecx
ffffffffc0011dd8:	89 5c 24 20          	mov    DWORD PTR [rsp+0x20],ebx
ffffffffc0011ddc:	44 89 cd             	mov    ebp,r9d
ffffffffc0011ddf:	44 88 44 24 0b       	mov    BYTE PTR [rsp+0xb],r8b
ffffffffc0011de4:	44 89 f7             	mov    edi,r14d
ffffffffc0011de7:	e8 04 11 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011dec:	44 89 ff             	mov    edi,r15d
ffffffffc0011def:	e8 0c 11 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0011df4:	89 c3                	mov    ebx,eax
ffffffffc0011df6:	0c 80                	or     al,0x80
ffffffffc0011df8:	44 89 ff             	mov    edi,r15d
ffffffffc0011dfb:	0f b6 f0             	movzx  esi,al
ffffffffc0011dfe:	e8 ed 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e03:	44 89 ef             	mov    edi,r13d
ffffffffc0011e06:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0011e0b:	e8 e0 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e10:	44 89 f7             	mov    edi,r14d
ffffffffc0011e13:	31 f6                	xor    esi,esi
ffffffffc0011e15:	44 89 74 24 18       	mov    DWORD PTR [rsp+0x18],r14d
ffffffffc0011e1a:	e8 d1 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e1f:	0f b6 f3             	movzx  esi,bl
ffffffffc0011e22:	44 89 ff             	mov    edi,r15d
ffffffffc0011e25:	e8 c6 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e2a:	44 89 ff             	mov    edi,r15d
ffffffffc0011e2d:	be 03 00 00 00       	mov    esi,0x3
ffffffffc0011e32:	e8 b9 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e37:	8b 5c 24 20          	mov    ebx,DWORD PTR [rsp+0x20]
ffffffffc0011e3b:	89 e8                	mov    eax,ebp
ffffffffc0011e3d:	89 6c 24 14          	mov    DWORD PTR [rsp+0x14],ebp
ffffffffc0011e41:	8b 6c 24 24          	mov    ebp,DWORD PTR [rsp+0x24]
ffffffffc0011e45:	24 a7                	and    al,0xa7
ffffffffc0011e47:	0f b6 f0             	movzx  esi,al
ffffffffc0011e4a:	89 df                	mov    edi,ebx
ffffffffc0011e4c:	e8 9f 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e51:	89 ef                	mov    edi,ebp
ffffffffc0011e53:	be 0f 00 00 00       	mov    esi,0xf
ffffffffc0011e58:	e8 93 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e5d:	89 ef                	mov    edi,ebp
ffffffffc0011e5f:	e8 9c 10 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0011e64:	41 89 c6             	mov    r14d,eax
ffffffffc0011e67:	44 22 74 24 0b       	and    r14b,BYTE PTR [rsp+0xb]
ffffffffc0011e6c:	89 ef                	mov    edi,ebp
ffffffffc0011e6e:	44 89 f0             	mov    eax,r14d
ffffffffc0011e71:	0c 10                	or     al,0x10
ffffffffc0011e73:	0f b6 f0             	movzx  esi,al
ffffffffc0011e76:	e8 75 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e7b:	44 89 ef             	mov    edi,r13d
ffffffffc0011e7e:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc0011e83:	e8 68 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011e88:	44 89 ef             	mov    edi,r13d
ffffffffc0011e8b:	e8 70 10 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0011e90:	3c 2b                	cmp    al,0x2b
ffffffffc0011e92:	0f 85 c8 00 00 00    	jne    ffffffffc0011f60 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x290>
ffffffffc0011e98:	41 0f b6 f6          	movzx  esi,r14b
ffffffffc0011e9c:	89 ef                	mov    edi,ebp
ffffffffc0011e9e:	e8 4d 10 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc0011ea3:	8b 4c 24 18          	mov    ecx,DWORD PTR [rsp+0x18]
ffffffffc0011ea7:	8a 44 24 0c          	mov    al,BYTE PTR [rsp+0xc]
ffffffffc0011eab:	66 45 89 6c 24 02    	mov    WORD PTR [r12+0x2],r13w
ffffffffc0011eb1:	41 c6 44 24 04 ff    	mov    BYTE PTR [r12+0x4],0xff
ffffffffc0011eb7:	66 45 89 6c 24 06    	mov    WORD PTR [r12+0x6],r13w
ffffffffc0011ebd:	41 c6 44 24 08 ff    	mov    BYTE PTR [r12+0x8],0xff
ffffffffc0011ec3:	66 45 89 6c 24 0a    	mov    WORD PTR [r12+0xa],r13w
ffffffffc0011ec9:	41 c6 44 24 0c ff    	mov    BYTE PTR [r12+0xc],0xff
ffffffffc0011ecf:	66 41 89 4c 24 0e    	mov    WORD PTR [r12+0xe],cx
ffffffffc0011ed5:	41 88 44 24 10       	mov    BYTE PTR [r12+0x10],al
ffffffffc0011eda:	8a 44 24 0d          	mov    al,BYTE PTR [rsp+0xd]
ffffffffc0011ede:	66 41 89 4c 24 12    	mov    WORD PTR [r12+0x12],cx
ffffffffc0011ee4:	41 c6 44 24 14 ff    	mov    BYTE PTR [r12+0x14],0xff
ffffffffc0011eea:	66 41 89 5c 24 16    	mov    WORD PTR [r12+0x16],bx
ffffffffc0011ef0:	41 88 44 24 18       	mov    BYTE PTR [r12+0x18],al
ffffffffc0011ef5:	8b 44 24 14          	mov    eax,DWORD PTR [rsp+0x14]
ffffffffc0011ef9:	66 41 89 5c 24 1a    	mov    WORD PTR [r12+0x1a],bx
ffffffffc0011eff:	41 88 44 24 1c       	mov    BYTE PTR [r12+0x1c],al
ffffffffc0011f04:	8a 44 24 0b          	mov    al,BYTE PTR [rsp+0xb]
ffffffffc0011f08:	66 45 89 7c 24 1e    	mov    WORD PTR [r12+0x1e],r15w
ffffffffc0011f0e:	41 c6 44 24 20 ff    	mov    BYTE PTR [r12+0x20],0xff
ffffffffc0011f14:	66 41 89 6c 24 22    	mov    WORD PTR [r12+0x22],bp
ffffffffc0011f1a:	41 88 44 24 24       	mov    BYTE PTR [r12+0x24],al
ffffffffc0011f1f:	0f b7 44 24 12       	movzx  eax,WORD PTR [rsp+0x12]
ffffffffc0011f24:	66 41 89 44 24 26    	mov    WORD PTR [r12+0x26],ax
ffffffffc0011f2a:	0f b7 44 24 10       	movzx  eax,WORD PTR [rsp+0x10]
ffffffffc0011f2f:	41 c6 44 24 28 ff    	mov    BYTE PTR [r12+0x28],0xff
ffffffffc0011f35:	66 41 89 44 24 2a    	mov    WORD PTR [r12+0x2a],ax
ffffffffc0011f3b:	0f b7 44 24 0e       	movzx  eax,WORD PTR [rsp+0xe]
ffffffffc0011f40:	41 c6 44 24 2c ff    	mov    BYTE PTR [r12+0x2c],0xff
ffffffffc0011f46:	66 41 89 44 24 2e    	mov    WORD PTR [r12+0x2e],ax
ffffffffc0011f4c:	8b 44 24 1c          	mov    eax,DWORD PTR [rsp+0x1c]
ffffffffc0011f50:	41 c6 44 24 30 ff    	mov    BYTE PTR [r12+0x30],0xff
ffffffffc0011f56:	66 41 89 44 24 32    	mov    WORD PTR [r12+0x32],ax
ffffffffc0011f5c:	31 c0                	xor    eax,eax
ffffffffc0011f5e:	eb 16                	jmp    ffffffffc0011f76 <_ZN9libkernel3out4uart8UartPort3new17h5e2403a57bb1aa43E+0x2a6>
ffffffffc0011f60:	66 b8 01 00          	mov    ax,0x1
ffffffffc0011f64:	49 c7 44 24 08 f0 6d 	mov    QWORD PTR [r12+0x8],0xffffffffc0016df0
ffffffffc0011f6b:	01 c0 
ffffffffc0011f6d:	49 c7 44 24 10 15 00 	mov    QWORD PTR [r12+0x10],0x15
ffffffffc0011f74:	00 00 
ffffffffc0011f76:	66 41 89 04 24       	mov    WORD PTR [r12],ax
ffffffffc0011f7b:	4c 89 e0             	mov    rax,r12
ffffffffc0011f7e:	48 83 c4 28          	add    rsp,0x28
ffffffffc0011f82:	5b                   	pop    rbx
ffffffffc0011f83:	41 5c                	pop    r12
ffffffffc0011f85:	41 5d                	pop    r13
ffffffffc0011f87:	41 5e                	pop    r14
ffffffffc0011f89:	41 5f                	pop    r15
ffffffffc0011f8b:	5d                   	pop    rbp
ffffffffc0011f8c:	c3                   	ret    
ffffffffc0011f8d:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011f92:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc0011f99:	48 c7 c2 20 6d 01 c0 	mov    rdx,0xffffffffc0016d20
ffffffffc0011fa0:	e8 8b 26 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011fa5:	0f 0b                	ud2    
ffffffffc0011fa7:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011fac:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc0011fb3:	48 c7 c2 78 6d 01 c0 	mov    rdx,0xffffffffc0016d78
ffffffffc0011fba:	e8 71 26 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011fbf:	0f 0b                	ud2    
ffffffffc0011fc1:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011fc6:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc0011fcd:	48 c7 c2 90 6d 01 c0 	mov    rdx,0xffffffffc0016d90
ffffffffc0011fd4:	e8 57 26 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011fd9:	0f 0b                	ud2    
ffffffffc0011fdb:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011fe0:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc0011fe7:	48 c7 c2 a8 6d 01 c0 	mov    rdx,0xffffffffc0016da8
ffffffffc0011fee:	e8 3d 26 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0011ff3:	0f 0b                	ud2    
ffffffffc0011ff5:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0011ffa:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc0012001:	48 c7 c2 c0 6d 01 c0 	mov    rdx,0xffffffffc0016dc0
ffffffffc0012008:	e8 23 26 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001200d:	0f 0b                	ud2    
ffffffffc001200f:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0012014:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc001201b:	48 c7 c2 d8 6d 01 c0 	mov    rdx,0xffffffffc0016dd8
ffffffffc0012022:	e8 09 26 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0012027:	0f 0b                	ud2    
ffffffffc0012029:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001202e:	48 c7 c7 40 6d 01 c0 	mov    rdi,0xffffffffc0016d40
ffffffffc0012035:	48 c7 c2 60 6d 01 c0 	mov    rdx,0xffffffffc0016d60
ffffffffc001203c:	e8 ef 25 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0012041:	0f 0b                	ud2    
ffffffffc0012043:	cc                   	int3   
ffffffffc0012044:	cc                   	int3   
ffffffffc0012045:	cc                   	int3   
ffffffffc0012046:	cc                   	int3   
ffffffffc0012047:	cc                   	int3   
ffffffffc0012048:	cc                   	int3   
ffffffffc0012049:	cc                   	int3   
ffffffffc001204a:	cc                   	int3   
ffffffffc001204b:	cc                   	int3   
ffffffffc001204c:	cc                   	int3   
ffffffffc001204d:	cc                   	int3   
ffffffffc001204e:	cc                   	int3   
ffffffffc001204f:	cc                   	int3   

ffffffffc0012050 <_ZN4core3ptr63drop_in_place$LT$$RF$mut$u20$libkernel..out..uart..UartPort$GT$17hb15b4cc0610d417eE.llvm.6580611916572223585>:
ffffffffc0012050:	c3                   	ret    
ffffffffc0012051:	cc                   	int3   
ffffffffc0012052:	cc                   	int3   
ffffffffc0012053:	cc                   	int3   
ffffffffc0012054:	cc                   	int3   
ffffffffc0012055:	cc                   	int3   
ffffffffc0012056:	cc                   	int3   
ffffffffc0012057:	cc                   	int3   
ffffffffc0012058:	cc                   	int3   
ffffffffc0012059:	cc                   	int3   
ffffffffc001205a:	cc                   	int3   
ffffffffc001205b:	cc                   	int3   
ffffffffc001205c:	cc                   	int3   
ffffffffc001205d:	cc                   	int3   
ffffffffc001205e:	cc                   	int3   
ffffffffc001205f:	cc                   	int3   

ffffffffc0012060 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585>:
ffffffffc0012060:	55                   	push   rbp
ffffffffc0012061:	41 57                	push   r15
ffffffffc0012063:	41 56                	push   r14
ffffffffc0012065:	41 55                	push   r13
ffffffffc0012067:	41 54                	push   r12
ffffffffc0012069:	53                   	push   rbx
ffffffffc001206a:	48 83 ec 18          	sub    rsp,0x18
ffffffffc001206e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0012071:	41 89 f7             	mov    r15d,esi
ffffffffc0012074:	c7 44 24 0c 00 00 00 	mov    DWORD PTR [rsp+0xc],0x0
ffffffffc001207b:	00 
ffffffffc001207c:	81 fe 80 00 00 00    	cmp    esi,0x80
ffffffffc0012082:	73 0f                	jae    ffffffffc0012093 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0x33>
ffffffffc0012084:	44 88 7c 24 0c       	mov    BYTE PTR [rsp+0xc],r15b
ffffffffc0012089:	b9 01 00 00 00       	mov    ecx,0x1
ffffffffc001208e:	e9 a0 00 00 00       	jmp    ffffffffc0012133 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0xd3>
ffffffffc0012093:	44 89 fa             	mov    edx,r15d
ffffffffc0012096:	41 81 ff 00 08 00 00 	cmp    r15d,0x800
ffffffffc001209d:	73 1e                	jae    ffffffffc00120bd <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0x5d>
ffffffffc001209f:	c1 ea 06             	shr    edx,0x6
ffffffffc00120a2:	41 80 e7 3f          	and    r15b,0x3f
ffffffffc00120a6:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc00120ab:	80 ca c0             	or     dl,0xc0
ffffffffc00120ae:	41 80 cf 80          	or     r15b,0x80
ffffffffc00120b2:	88 54 24 0c          	mov    BYTE PTR [rsp+0xc],dl
ffffffffc00120b6:	44 88 7c 24 0d       	mov    BYTE PTR [rsp+0xd],r15b
ffffffffc00120bb:	eb 73                	jmp    ffffffffc0012130 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0xd0>
ffffffffc00120bd:	41 81 ff 00 00 01 00 	cmp    r15d,0x10000
ffffffffc00120c4:	73 2e                	jae    ffffffffc00120f4 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0x94>
ffffffffc00120c6:	44 89 f9             	mov    ecx,r15d
ffffffffc00120c9:	c1 ea 0c             	shr    edx,0xc
ffffffffc00120cc:	41 80 e7 3f          	and    r15b,0x3f
ffffffffc00120d0:	c1 e9 06             	shr    ecx,0x6
ffffffffc00120d3:	80 ca e0             	or     dl,0xe0
ffffffffc00120d6:	41 80 cf 80          	or     r15b,0x80
ffffffffc00120da:	80 e1 3f             	and    cl,0x3f
ffffffffc00120dd:	88 54 24 0c          	mov    BYTE PTR [rsp+0xc],dl
ffffffffc00120e1:	80 c9 80             	or     cl,0x80
ffffffffc00120e4:	88 4c 24 0d          	mov    BYTE PTR [rsp+0xd],cl
ffffffffc00120e8:	44 88 7c 24 0e       	mov    BYTE PTR [rsp+0xe],r15b
ffffffffc00120ed:	b9 03 00 00 00       	mov    ecx,0x3
ffffffffc00120f2:	eb 3c                	jmp    ffffffffc0012130 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0xd0>
ffffffffc00120f4:	44 89 f9             	mov    ecx,r15d
ffffffffc00120f7:	c1 ea 12             	shr    edx,0x12
ffffffffc00120fa:	c1 e9 0c             	shr    ecx,0xc
ffffffffc00120fd:	80 ca f0             	or     dl,0xf0
ffffffffc0012100:	80 e1 3f             	and    cl,0x3f
ffffffffc0012103:	88 54 24 0c          	mov    BYTE PTR [rsp+0xc],dl
ffffffffc0012107:	80 c9 80             	or     cl,0x80
ffffffffc001210a:	88 4c 24 0d          	mov    BYTE PTR [rsp+0xd],cl
ffffffffc001210e:	44 89 f9             	mov    ecx,r15d
ffffffffc0012111:	41 80 e7 3f          	and    r15b,0x3f
ffffffffc0012115:	c1 e9 06             	shr    ecx,0x6
ffffffffc0012118:	41 80 cf 80          	or     r15b,0x80
ffffffffc001211c:	80 e1 3f             	and    cl,0x3f
ffffffffc001211f:	80 c9 80             	or     cl,0x80
ffffffffc0012122:	88 4c 24 0e          	mov    BYTE PTR [rsp+0xe],cl
ffffffffc0012126:	b9 04 00 00 00       	mov    ecx,0x4
ffffffffc001212b:	44 88 7c 24 0f       	mov    BYTE PTR [rsp+0xf],r15b
ffffffffc0012130:	41 89 d7             	mov    r15d,edx
ffffffffc0012133:	8a 58 26             	mov    bl,BYTE PTR [rax+0x26]
ffffffffc0012136:	44 8a 60 02          	mov    r12b,BYTE PTR [rax+0x2]
ffffffffc001213a:	0f b7 68 24          	movzx  ebp,WORD PTR [rax+0x24]
ffffffffc001213e:	44 0f b7 30          	movzx  r14d,WORD PTR [rax]
ffffffffc0012142:	48 8d 4c 0c 0c       	lea    rcx,[rsp+rcx*1+0xc]
ffffffffc0012147:	4c 8d 6c 24 0c       	lea    r13,[rsp+0xc]
ffffffffc001214c:	48 89 4c 24 10       	mov    QWORD PTR [rsp+0x10],rcx
ffffffffc0012151:	80 e3 20             	and    bl,0x20
ffffffffc0012154:	66 66 66 2e 0f 1f 84 	data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001215b:	00 00 00 00 00 
ffffffffc0012160:	89 ef                	mov    edi,ebp
ffffffffc0012162:	e8 99 0d 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0012167:	84 c3                	test   bl,al
ffffffffc0012169:	74 f5                	je     ffffffffc0012160 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0x100>
ffffffffc001216b:	45 20 e7             	and    r15b,r12b
ffffffffc001216e:	44 89 f7             	mov    edi,r14d
ffffffffc0012171:	49 ff c5             	inc    r13
ffffffffc0012174:	41 0f b6 f7          	movzx  esi,r15b
ffffffffc0012178:	e8 73 0d 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc001217d:	4c 3b 6c 24 10       	cmp    r13,QWORD PTR [rsp+0x10]
ffffffffc0012182:	74 07                	je     ffffffffc001218b <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0x12b>
ffffffffc0012184:	45 0f b6 7d 00       	movzx  r15d,BYTE PTR [r13+0x0]
ffffffffc0012189:	eb d5                	jmp    ffffffffc0012160 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h8c007fc577c15269E.llvm.6580611916572223585+0x100>
ffffffffc001218b:	31 c0                	xor    eax,eax
ffffffffc001218d:	48 83 c4 18          	add    rsp,0x18
ffffffffc0012191:	5b                   	pop    rbx
ffffffffc0012192:	41 5c                	pop    r12
ffffffffc0012194:	41 5d                	pop    r13
ffffffffc0012196:	41 5e                	pop    r14
ffffffffc0012198:	41 5f                	pop    r15
ffffffffc001219a:	5d                   	pop    rbp
ffffffffc001219b:	c3                   	ret    
ffffffffc001219c:	cc                   	int3   
ffffffffc001219d:	cc                   	int3   
ffffffffc001219e:	cc                   	int3   
ffffffffc001219f:	cc                   	int3   

ffffffffc00121a0 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hddfbbe4385c1a866E.llvm.6580611916572223585>:
ffffffffc00121a0:	48 83 ec 38          	sub    rsp,0x38
ffffffffc00121a4:	48 8b 4e 20          	mov    rcx,QWORD PTR [rsi+0x20]
ffffffffc00121a8:	48 8b 56 28          	mov    rdx,QWORD PTR [rsi+0x28]
ffffffffc00121ac:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc00121af:	48 89 e7             	mov    rdi,rsp
ffffffffc00121b2:	48 89 4c 24 28       	mov    QWORD PTR [rsp+0x28],rcx
ffffffffc00121b7:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
ffffffffc00121bb:	48 89 54 24 30       	mov    QWORD PTR [rsp+0x30],rdx
ffffffffc00121c0:	48 8b 56 18          	mov    rdx,QWORD PTR [rsi+0x18]
ffffffffc00121c4:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc00121c8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
ffffffffc00121cb:	48 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],rcx
ffffffffc00121d0:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
ffffffffc00121d4:	48 89 54 24 20       	mov    QWORD PTR [rsp+0x20],rdx
ffffffffc00121d9:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc00121de:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc00121e5:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
ffffffffc00121ea:	48 89 4c 24 10       	mov    QWORD PTR [rsp+0x10],rcx
ffffffffc00121ef:	e8 0c 11 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc00121f4:	48 83 c4 38          	add    rsp,0x38
ffffffffc00121f8:	c3                   	ret    
ffffffffc00121f9:	cc                   	int3   
ffffffffc00121fa:	cc                   	int3   
ffffffffc00121fb:	cc                   	int3   
ffffffffc00121fc:	cc                   	int3   
ffffffffc00121fd:	cc                   	int3   
ffffffffc00121fe:	cc                   	int3   
ffffffffc00121ff:	cc                   	int3   

ffffffffc0012200 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17hd9a23eeac737fa15E.llvm.6580611916572223585>:
ffffffffc0012200:	55                   	push   rbp
ffffffffc0012201:	41 57                	push   r15
ffffffffc0012203:	41 56                	push   r14
ffffffffc0012205:	41 55                	push   r13
ffffffffc0012207:	41 54                	push   r12
ffffffffc0012209:	53                   	push   rbx
ffffffffc001220a:	48 83 ec 08          	sub    rsp,0x8
ffffffffc001220e:	48 89 14 24          	mov    QWORD PTR [rsp],rdx
ffffffffc0012212:	48 85 d2             	test   rdx,rdx
ffffffffc0012215:	74 5c                	je     ffffffffc0012273 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17hd9a23eeac737fa15E.llvm.6580611916572223585+0x73>
ffffffffc0012217:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc001221a:	48 01 34 24          	add    QWORD PTR [rsp],rsi
ffffffffc001221e:	49 89 f4             	mov    r12,rsi
ffffffffc0012221:	0f b7 68 24          	movzx  ebp,WORD PTR [rax+0x24]
ffffffffc0012225:	44 0f b7 38          	movzx  r15d,WORD PTR [rax]
ffffffffc0012229:	8a 58 26             	mov    bl,BYTE PTR [rax+0x26]
ffffffffc001222c:	44 8a 68 02          	mov    r13b,BYTE PTR [rax+0x2]
ffffffffc0012230:	80 e3 20             	and    bl,0x20
ffffffffc0012233:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001223a:	84 00 00 00 00 00 
ffffffffc0012240:	45 8a 34 24          	mov    r14b,BYTE PTR [r12]
ffffffffc0012244:	66 66 66 2e 0f 1f 84 	data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001224b:	00 00 00 00 00 
ffffffffc0012250:	89 ef                	mov    edi,ebp
ffffffffc0012252:	e8 a9 0c 00 00       	call   ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>
ffffffffc0012257:	84 c3                	test   bl,al
ffffffffc0012259:	74 f5                	je     ffffffffc0012250 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17hd9a23eeac737fa15E.llvm.6580611916572223585+0x50>
ffffffffc001225b:	45 20 ee             	and    r14b,r13b
ffffffffc001225e:	44 89 ff             	mov    edi,r15d
ffffffffc0012261:	49 ff c4             	inc    r12
ffffffffc0012264:	41 0f b6 f6          	movzx  esi,r14b
ffffffffc0012268:	e8 83 0c 00 00       	call   ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>
ffffffffc001226d:	4c 3b 24 24          	cmp    r12,QWORD PTR [rsp]
ffffffffc0012271:	75 cd                	jne    ffffffffc0012240 <_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17hd9a23eeac737fa15E.llvm.6580611916572223585+0x40>
ffffffffc0012273:	31 c0                	xor    eax,eax
ffffffffc0012275:	48 83 c4 08          	add    rsp,0x8
ffffffffc0012279:	5b                   	pop    rbx
ffffffffc001227a:	41 5c                	pop    r12
ffffffffc001227c:	41 5d                	pop    r13
ffffffffc001227e:	41 5e                	pop    r14
ffffffffc0012280:	41 5f                	pop    r15
ffffffffc0012282:	5d                   	pop    rbp
ffffffffc0012283:	c3                   	ret    
ffffffffc0012284:	cc                   	int3   
ffffffffc0012285:	cc                   	int3   
ffffffffc0012286:	cc                   	int3   
ffffffffc0012287:	cc                   	int3   
ffffffffc0012288:	cc                   	int3   
ffffffffc0012289:	cc                   	int3   
ffffffffc001228a:	cc                   	int3   
ffffffffc001228b:	cc                   	int3   
ffffffffc001228c:	cc                   	int3   
ffffffffc001228d:	cc                   	int3   
ffffffffc001228e:	cc                   	int3   
ffffffffc001228f:	cc                   	int3   

ffffffffc0012290 <_ZN4core9panicking19unreachable_display17h7178d045a8e9ce04E.llvm.2330526326397655001>:
ffffffffc0012290:	48 83 ec 48          	sub    rsp,0x48
ffffffffc0012294:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc0012299:	48 8d 7c 24 18       	lea    rdi,[rsp+0x18]
ffffffffc001229e:	48 c7 c6 20 70 01 c0 	mov    rsi,0xffffffffc0017020
ffffffffc00122a5:	48 c7 44 24 08 10 70 	mov    QWORD PTR [rsp+0x8],0xffffffffc0017010
ffffffffc00122ac:	01 c0 
ffffffffc00122ae:	48 c7 44 24 18 88 6e 	mov    QWORD PTR [rsp+0x18],0xffffffffc0016e88
ffffffffc00122b5:	01 c0 
ffffffffc00122b7:	48 c7 44 24 20 01 00 	mov    QWORD PTR [rsp+0x20],0x1
ffffffffc00122be:	00 00 
ffffffffc00122c0:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
ffffffffc00122c7:	00 00 
ffffffffc00122c9:	48 c7 44 24 10 c0 2e 	mov    QWORD PTR [rsp+0x10],0xffffffffc0012ec0
ffffffffc00122d0:	01 c0 
ffffffffc00122d2:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc00122d7:	48 c7 44 24 40 01 00 	mov    QWORD PTR [rsp+0x40],0x1
ffffffffc00122de:	00 00 
ffffffffc00122e0:	e8 1b 24 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc00122e5:	0f 0b                	ud2    
ffffffffc00122e7:	cc                   	int3   
ffffffffc00122e8:	cc                   	int3   
ffffffffc00122e9:	cc                   	int3   
ffffffffc00122ea:	cc                   	int3   
ffffffffc00122eb:	cc                   	int3   
ffffffffc00122ec:	cc                   	int3   
ffffffffc00122ed:	cc                   	int3   
ffffffffc00122ee:	cc                   	int3   
ffffffffc00122ef:	cc                   	int3   

ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>:
ffffffffc00122f0:	41 56                	push   r14
ffffffffc00122f2:	53                   	push   rbx
ffffffffc00122f3:	48 83 ec 38          	sub    rsp,0x38
ffffffffc00122f7:	8a 47 34             	mov    al,BYTE PTR [rdi+0x34]
ffffffffc00122fa:	48 89 fb             	mov    rbx,rdi
ffffffffc00122fd:	49 89 f6             	mov    r14,rsi
ffffffffc0012300:	0f b6 f8             	movzx  edi,al
ffffffffc0012303:	e8 d8 0b 00 00       	call   ffffffffc0012ee0 <_ZN4spin4once6status6Status13new_unchecked17h84cb4dc5af5dc742E>
ffffffffc0012308:	0f b6 c0             	movzx  eax,al
ffffffffc001230b:	ff 24 c5 38 6e 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe91c8]
ffffffffc0012312:	b1 01                	mov    cl,0x1
ffffffffc0012314:	31 c0                	xor    eax,eax
ffffffffc0012316:	f0 0f b0 4b 34       	lock cmpxchg BYTE PTR [rbx+0x34],cl
ffffffffc001231b:	0f b6 f8             	movzx  edi,al
ffffffffc001231e:	e8 bd 0b 00 00       	call   ffffffffc0012ee0 <_ZN4spin4once6status6Status13new_unchecked17h84cb4dc5af5dc742E>
ffffffffc0012323:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
ffffffffc0012326:	48 8b 01             	mov    rax,QWORD PTR [rcx]
ffffffffc0012329:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
ffffffffc0012330:	48 85 c0             	test   rax,rax
ffffffffc0012333:	0f 84 a5 00 00 00    	je     ffffffffc00123de <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE+0xee>
ffffffffc0012339:	48 89 e7             	mov    rdi,rsp
ffffffffc001233c:	ff d0                	call   rax
ffffffffc001233e:	8b 44 24 30          	mov    eax,DWORD PTR [rsp+0x30]
ffffffffc0012342:	89 43 30             	mov    DWORD PTR [rbx+0x30],eax
ffffffffc0012345:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
ffffffffc001234a:	48 89 43 28          	mov    QWORD PTR [rbx+0x28],rax
ffffffffc001234e:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
ffffffffc0012353:	48 89 43 20          	mov    QWORD PTR [rbx+0x20],rax
ffffffffc0012357:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
ffffffffc001235c:	48 89 43 18          	mov    QWORD PTR [rbx+0x18],rax
ffffffffc0012360:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
ffffffffc0012365:	48 89 43 10          	mov    QWORD PTR [rbx+0x10],rax
ffffffffc0012369:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc001236d:	48 8b 4c 24 08       	mov    rcx,QWORD PTR [rsp+0x8]
ffffffffc0012372:	48 89 4b 08          	mov    QWORD PTR [rbx+0x8],rcx
ffffffffc0012376:	48 89 03             	mov    QWORD PTR [rbx],rax
ffffffffc0012379:	c6 43 34 02          	mov    BYTE PTR [rbx+0x34],0x2
ffffffffc001237d:	eb 15                	jmp    ffffffffc0012394 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE+0xa4>
ffffffffc001237f:	90                   	nop
ffffffffc0012380:	0f b6 43 34          	movzx  eax,BYTE PTR [rbx+0x34]
ffffffffc0012384:	0f b6 f8             	movzx  edi,al
ffffffffc0012387:	e8 54 0b 00 00       	call   ffffffffc0012ee0 <_ZN4spin4once6status6Status13new_unchecked17h84cb4dc5af5dc742E>
ffffffffc001238c:	3c 01                	cmp    al,0x1
ffffffffc001238e:	74 f0                	je     ffffffffc0012380 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE+0x90>
ffffffffc0012390:	3c 02                	cmp    al,0x2
ffffffffc0012392:	75 0b                	jne    ffffffffc001239f <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE+0xaf>
ffffffffc0012394:	48 89 d8             	mov    rax,rbx
ffffffffc0012397:	48 83 c4 38          	add    rsp,0x38
ffffffffc001239b:	5b                   	pop    rbx
ffffffffc001239c:	41 5e                	pop    r14
ffffffffc001239e:	c3                   	ret    
ffffffffc001239f:	84 c0                	test   al,al
ffffffffc00123a1:	75 07                	jne    ffffffffc00123aa <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE+0xba>
ffffffffc00123a3:	e8 e8 fe ff ff       	call   ffffffffc0012290 <_ZN4core9panicking19unreachable_display17h7178d045a8e9ce04E.llvm.2330526326397655001>
ffffffffc00123a8:	0f 0b                	ud2    
ffffffffc00123aa:	be 26 00 00 00       	mov    esi,0x26
ffffffffc00123af:	48 c7 c7 30 6f 01 c0 	mov    rdi,0xffffffffc0016f30
ffffffffc00123b6:	48 c7 c2 a8 6f 01 c0 	mov    rdx,0xffffffffc0016fa8
ffffffffc00123bd:	e8 6e 22 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00123c2:	0f 0b                	ud2    
ffffffffc00123c4:	be 0d 00 00 00       	mov    esi,0xd
ffffffffc00123c9:	48 c7 c7 c0 6f 01 c0 	mov    rdi,0xffffffffc0016fc0
ffffffffc00123d0:	48 c7 c2 d0 6f 01 c0 	mov    rdx,0xffffffffc0016fd0
ffffffffc00123d7:	e8 54 22 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00123dc:	0f 0b                	ud2    
ffffffffc00123de:	be 2a 00 00 00       	mov    esi,0x2a
ffffffffc00123e3:	48 c7 c7 98 6e 01 c0 	mov    rdi,0xffffffffc0016e98
ffffffffc00123ea:	48 c7 c2 18 6f 01 c0 	mov    rdx,0xffffffffc0016f18
ffffffffc00123f1:	e8 3a 22 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00123f6:	0f 0b                	ud2    
ffffffffc00123f8:	cc                   	int3   
ffffffffc00123f9:	cc                   	int3   
ffffffffc00123fa:	cc                   	int3   
ffffffffc00123fb:	cc                   	int3   
ffffffffc00123fc:	cc                   	int3   
ffffffffc00123fd:	cc                   	int3   
ffffffffc00123fe:	cc                   	int3   
ffffffffc00123ff:	cc                   	int3   

ffffffffc0012400 <_ZN4core3ptr44drop_in_place$LT$core..alloc..AllocError$GT$17h26760b61b7f7b19aE.llvm.10247169838892840880>:
ffffffffc0012400:	c3                   	ret    
ffffffffc0012401:	cc                   	int3   
ffffffffc0012402:	cc                   	int3   
ffffffffc0012403:	cc                   	int3   
ffffffffc0012404:	cc                   	int3   
ffffffffc0012405:	cc                   	int3   
ffffffffc0012406:	cc                   	int3   
ffffffffc0012407:	cc                   	int3   
ffffffffc0012408:	cc                   	int3   
ffffffffc0012409:	cc                   	int3   
ffffffffc001240a:	cc                   	int3   
ffffffffc001240b:	cc                   	int3   
ffffffffc001240c:	cc                   	int3   
ffffffffc001240d:	cc                   	int3   
ffffffffc001240e:	cc                   	int3   
ffffffffc001240f:	cc                   	int3   

ffffffffc0012410 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE>:
ffffffffc0012410:	55                   	push   rbp
ffffffffc0012411:	41 57                	push   r15
ffffffffc0012413:	41 56                	push   r14
ffffffffc0012415:	41 55                	push   r13
ffffffffc0012417:	41 54                	push   r12
ffffffffc0012419:	53                   	push   rbx
ffffffffc001241a:	48 81 ec 98 00 00 00 	sub    rsp,0x98
ffffffffc0012421:	48 85 c9             	test   rcx,rcx
ffffffffc0012424:	0f 84 61 02 00 00    	je     ffffffffc001268b <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0x27b>
ffffffffc001242a:	48 89 cb             	mov    rbx,rcx
ffffffffc001242d:	48 81 c3 00 10 00 00 	add    rbx,0x1000
ffffffffc0012434:	0f 82 37 02 00 00    	jb     ffffffffc0012671 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0x261>
ffffffffc001243a:	49 89 d7             	mov    r15,rdx
ffffffffc001243d:	48 ff cb             	dec    rbx
ffffffffc0012440:	49 89 fe             	mov    r14,rdi
ffffffffc0012443:	48 89 74 24 50       	mov    QWORD PTR [rsp+0x50],rsi
ffffffffc0012448:	48 8d 44 24 68       	lea    rax,[rsp+0x68]
ffffffffc001244d:	48 8d 74 24 20       	lea    rsi,[rsp+0x20]
ffffffffc0012452:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0012459:	48 c7 44 24 68 50 71 	mov    QWORD PTR [rsp+0x68],0xffffffffc0017150
ffffffffc0012460:	01 c0 
ffffffffc0012462:	48 c7 44 24 70 01 00 	mov    QWORD PTR [rsp+0x70],0x1
ffffffffc0012469:	00 00 
ffffffffc001246b:	48 c7 44 24 78 00 00 	mov    QWORD PTR [rsp+0x78],0x0
ffffffffc0012472:	00 00 
ffffffffc0012474:	48 c7 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],0xffffffffc0017060
ffffffffc001247b:	00 60 70 01 c0 
ffffffffc0012480:	4c 89 44 24 58       	mov    QWORD PTR [rsp+0x58],r8
ffffffffc0012485:	4c 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],r9
ffffffffc001248a:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
ffffffffc0012491:	00 00 00 00 00 
ffffffffc0012496:	48 c7 44 24 20 b8 95 	mov    QWORD PTR [rsp+0x20],0xffffffffc00195b8
ffffffffc001249d:	01 c0 
ffffffffc001249f:	49 81 e7 00 f0 ff ff 	and    r15,0xfffffffffffff000
ffffffffc00124a6:	48 81 e3 00 f0 ff ff 	and    rbx,0xfffffffffffff000
ffffffffc00124ad:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
ffffffffc00124b2:	48 c7 44 24 18 a0 32 	mov    QWORD PTR [rsp+0x18],0xffffffffc00132a0
ffffffffc00124b9:	01 c0 
ffffffffc00124bb:	4c 01 fb             	add    rbx,r15
ffffffffc00124be:	e8 2d fe ff ff       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc00124c3:	48 89 c5             	mov    rbp,rax
ffffffffc00124c6:	41 b5 01             	mov    r13b,0x1
ffffffffc00124c9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc00124d0:	31 c0                	xor    eax,eax
ffffffffc00124d2:	f0 44 0f b0 6d 00    	lock cmpxchg BYTE PTR [rbp+0x0],r13b
ffffffffc00124d8:	74 0a                	je     ffffffffc00124e4 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0xd4>
ffffffffc00124da:	0f b6 45 00          	movzx  eax,BYTE PTR [rbp+0x0]
ffffffffc00124de:	84 c0                	test   al,al
ffffffffc00124e0:	75 f8                	jne    ffffffffc00124da <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0xca>
ffffffffc00124e2:	eb ec                	jmp    ffffffffc00124d0 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0xc0>
ffffffffc00124e4:	48 89 e8             	mov    rax,rbp
ffffffffc00124e7:	4c 8d 64 24 20       	lea    r12,[rsp+0x20]
ffffffffc00124ec:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc00124f1:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc00124f8:	48 c7 44 24 20 88 70 	mov    QWORD PTR [rsp+0x20],0xffffffffc0017088
ffffffffc00124ff:	01 c0 
ffffffffc0012501:	48 c7 44 24 28 01 00 	mov    QWORD PTR [rsp+0x28],0x1
ffffffffc0012508:	00 00 
ffffffffc001250a:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc0012511:	00 00 
ffffffffc0012513:	48 83 c0 02          	add    rax,0x2
ffffffffc0012517:	4c 89 e2             	mov    rdx,r12
ffffffffc001251a:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
ffffffffc001251f:	48 8d 44 24 10       	lea    rax,[rsp+0x10]
ffffffffc0012524:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
ffffffffc0012529:	48 c7 44 24 48 01 00 	mov    QWORD PTR [rsp+0x48],0x1
ffffffffc0012530:	00 00 
ffffffffc0012532:	e8 c9 0d 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0012537:	c6 45 00 00          	mov    BYTE PTR [rbp+0x0],0x0
ffffffffc001253b:	4c 89 24 24          	mov    QWORD PTR [rsp],r12
ffffffffc001253f:	4c 8b a4 24 d8 00 00 	mov    r12,QWORD PTR [rsp+0xd8]
ffffffffc0012546:	00 
ffffffffc0012547:	4c 8b 84 24 d0 00 00 	mov    r8,QWORD PTR [rsp+0xd0]
ffffffffc001254e:	00 
ffffffffc001254f:	4c 89 ff             	mov    rdi,r15
ffffffffc0012552:	48 89 de             	mov    rsi,rbx
ffffffffc0012555:	48 8b 44 24 50       	mov    rax,QWORD PTR [rsp+0x50]
ffffffffc001255a:	48 8b 54 24 58       	mov    rdx,QWORD PTR [rsp+0x58]
ffffffffc001255f:	48 8b 4c 24 60       	mov    rcx,QWORD PTR [rsp+0x60]
ffffffffc0012564:	4d 89 e1             	mov    r9,r12
ffffffffc0012567:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
ffffffffc001256c:	e8 3f 01 00 00       	call   ffffffffc00126b0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E>
ffffffffc0012571:	48 8d 44 24 68       	lea    rax,[rsp+0x68]
ffffffffc0012576:	48 8d 74 24 20       	lea    rsi,[rsp+0x20]
ffffffffc001257b:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0012582:	48 c7 44 24 68 70 71 	mov    QWORD PTR [rsp+0x68],0xffffffffc0017170
ffffffffc0012589:	01 c0 
ffffffffc001258b:	48 c7 44 24 70 01 00 	mov    QWORD PTR [rsp+0x70],0x1
ffffffffc0012592:	00 00 
ffffffffc0012594:	48 c7 44 24 78 00 00 	mov    QWORD PTR [rsp+0x78],0x0
ffffffffc001259b:	00 00 
ffffffffc001259d:	48 c7 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],0xffffffffc0017060
ffffffffc00125a4:	00 60 70 01 c0 
ffffffffc00125a9:	48 c7 84 24 90 00 00 	mov    QWORD PTR [rsp+0x90],0x0
ffffffffc00125b0:	00 00 00 00 00 
ffffffffc00125b5:	48 c7 44 24 20 b8 95 	mov    QWORD PTR [rsp+0x20],0xffffffffc00195b8
ffffffffc00125bc:	01 c0 
ffffffffc00125be:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
ffffffffc00125c3:	48 c7 44 24 18 a0 32 	mov    QWORD PTR [rsp+0x18],0xffffffffc00132a0
ffffffffc00125ca:	01 c0 
ffffffffc00125cc:	e8 1f fd ff ff       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc00125d1:	48 89 c5             	mov    rbp,rax
ffffffffc00125d4:	31 c0                	xor    eax,eax
ffffffffc00125d6:	f0 44 0f b0 6d 00    	lock cmpxchg BYTE PTR [rbp+0x0],r13b
ffffffffc00125dc:	74 13                	je     ffffffffc00125f1 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0x1e1>
ffffffffc00125de:	b1 01                	mov    cl,0x1
ffffffffc00125e0:	0f b6 45 00          	movzx  eax,BYTE PTR [rbp+0x0]
ffffffffc00125e4:	84 c0                	test   al,al
ffffffffc00125e6:	75 f8                	jne    ffffffffc00125e0 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0x1d0>
ffffffffc00125e8:	31 c0                	xor    eax,eax
ffffffffc00125ea:	f0 0f b0 4d 00       	lock cmpxchg BYTE PTR [rbp+0x0],cl
ffffffffc00125ef:	75 ef                	jne    ffffffffc00125e0 <_ZN9libkernel4memm6Mapper3map17hd0b3663c5a0724deE+0x1d0>
ffffffffc00125f1:	48 89 e8             	mov    rax,rbp
ffffffffc00125f4:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc00125f9:	48 8d 54 24 20       	lea    rdx,[rsp+0x20]
ffffffffc00125fe:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc0012605:	48 c7 44 24 20 88 70 	mov    QWORD PTR [rsp+0x20],0xffffffffc0017088
ffffffffc001260c:	01 c0 
ffffffffc001260e:	48 c7 44 24 28 01 00 	mov    QWORD PTR [rsp+0x28],0x1
ffffffffc0012615:	00 00 
ffffffffc0012617:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc001261e:	00 00 
ffffffffc0012620:	48 83 c0 02          	add    rax,0x2
ffffffffc0012624:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
ffffffffc0012629:	48 8d 44 24 10       	lea    rax,[rsp+0x10]
ffffffffc001262e:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
ffffffffc0012633:	48 c7 44 24 48 01 00 	mov    QWORD PTR [rsp+0x48],0x1
ffffffffc001263a:	00 00 
ffffffffc001263c:	e8 bf 0c 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0012641:	48 8b 84 24 d0 00 00 	mov    rax,QWORD PTR [rsp+0xd0]
ffffffffc0012648:	00 
ffffffffc0012649:	c6 45 00 00          	mov    BYTE PTR [rbp+0x0],0x0
ffffffffc001264d:	4d 89 3e             	mov    QWORD PTR [r14],r15
ffffffffc0012650:	49 89 5e 08          	mov    QWORD PTR [r14+0x8],rbx
ffffffffc0012654:	49 89 46 10          	mov    QWORD PTR [r14+0x10],rax
ffffffffc0012658:	4d 89 66 18          	mov    QWORD PTR [r14+0x18],r12
ffffffffc001265c:	4c 89 f0             	mov    rax,r14
ffffffffc001265f:	48 81 c4 98 00 00 00 	add    rsp,0x98
ffffffffc0012666:	5b                   	pop    rbx
ffffffffc0012667:	41 5c                	pop    r12
ffffffffc0012669:	41 5d                	pop    r13
ffffffffc001266b:	41 5e                	pop    r14
ffffffffc001266d:	41 5f                	pop    r15
ffffffffc001266f:	5d                   	pop    rbp
ffffffffc0012670:	c3                   	ret    
ffffffffc0012671:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0012676:	48 c7 c7 40 70 01 c0 	mov    rdi,0xffffffffc0017040
ffffffffc001267d:	48 c7 c2 28 71 01 c0 	mov    rdx,0xffffffffc0017128
ffffffffc0012684:	e8 a7 1f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0012689:	0f 0b                	ud2    
ffffffffc001268b:	be 1b 00 00 00       	mov    esi,0x1b
ffffffffc0012690:	48 c7 c7 f0 70 01 c0 	mov    rdi,0xffffffffc00170f0
ffffffffc0012697:	48 c7 c2 10 71 01 c0 	mov    rdx,0xffffffffc0017110
ffffffffc001269e:	e8 8d 1f 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00126a3:	0f 0b                	ud2    
ffffffffc00126a5:	cc                   	int3   
ffffffffc00126a6:	cc                   	int3   
ffffffffc00126a7:	cc                   	int3   
ffffffffc00126a8:	cc                   	int3   
ffffffffc00126a9:	cc                   	int3   
ffffffffc00126aa:	cc                   	int3   
ffffffffc00126ab:	cc                   	int3   
ffffffffc00126ac:	cc                   	int3   
ffffffffc00126ad:	cc                   	int3   
ffffffffc00126ae:	cc                   	int3   
ffffffffc00126af:	cc                   	int3   

ffffffffc00126b0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E>:
ffffffffc00126b0:	55                   	push   rbp
ffffffffc00126b1:	41 57                	push   r15
ffffffffc00126b3:	41 56                	push   r14
ffffffffc00126b5:	41 55                	push   r13
ffffffffc00126b7:	41 54                	push   r12
ffffffffc00126b9:	53                   	push   rbx
ffffffffc00126ba:	48 81 ec a8 00 00 00 	sub    rsp,0xa8
ffffffffc00126c1:	4c 89 44 24 68       	mov    QWORD PTR [rsp+0x68],r8
ffffffffc00126c6:	48 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],rcx
ffffffffc00126cb:	48 89 54 24 58       	mov    QWORD PTR [rsp+0x58],rdx
ffffffffc00126d0:	48 39 f7             	cmp    rdi,rsi
ffffffffc00126d3:	0f 8d 5c 05 00 00    	jge    ffffffffc0012c35 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x585>
ffffffffc00126d9:	48 8b 84 24 e0 00 00 	mov    rax,QWORD PTR [rsp+0xe0]
ffffffffc00126e0:	00 
ffffffffc00126e1:	48 89 f3             	mov    rbx,rsi
ffffffffc00126e4:	4c 89 4c 24 78       	mov    QWORD PTR [rsp+0x78],r9
ffffffffc00126e9:	48 8b 00             	mov    rax,QWORD PTR [rax]
ffffffffc00126ec:	48 83 c0 08          	add    rax,0x8
ffffffffc00126f0:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
ffffffffc00126f5:	b8 27 09 00 00       	mov    eax,0x927
ffffffffc00126fa:	48 89 7c 24 40       	mov    QWORD PTR [rsp+0x40],rdi
ffffffffc00126ff:	c4 e2 f8 f7 cf       	bextr  rcx,rdi,rax
ffffffffc0012704:	48 89 c8             	mov    rax,rcx
ffffffffc0012707:	48 89 4c 24 50       	mov    QWORD PTR [rsp+0x50],rcx
ffffffffc001270c:	4c 39 c9             	cmp    rcx,r9
ffffffffc001270f:	0f 83 f4 05 00 00    	jae    ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc0012715:	bf 04 00 00 00       	mov    edi,0x4
ffffffffc001271a:	e8 c1 08 00 00       	call   ffffffffc0012fe0 <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E>
ffffffffc001271f:	48 85 c0             	test   rax,rax
ffffffffc0012722:	0f 84 1f 05 00 00    	je     ffffffffc0012c47 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x597>
ffffffffc0012728:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
ffffffffc001272d:	48 89 da             	mov    rdx,rbx
ffffffffc0012730:	48 29 ca             	sub    rdx,rcx
ffffffffc0012733:	0f 80 28 05 00 00    	jo     ffffffffc0012c61 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5b1>
ffffffffc0012739:	48 81 fa ff ef ff ff 	cmp    rdx,0xffffffffffffefff
ffffffffc0012740:	0f 87 29 05 00 00    	ja     ffffffffc0012c6f <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5bf>
ffffffffc0012746:	48 89 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rax
ffffffffc001274d:	00 
ffffffffc001274e:	48 8b 44 24 68       	mov    rax,QWORD PTR [rsp+0x68]
ffffffffc0012753:	48 8b 54 24 50       	mov    rdx,QWORD PTR [rsp+0x50]
ffffffffc0012758:	4c 8b 34 d0          	mov    r14,QWORD PTR [rax+rdx*8]
ffffffffc001275c:	41 f6 c6 01          	test   r14b,0x1
ffffffffc0012760:	0f 85 8d 00 00 00    	jne    ffffffffc00127f3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x143>
ffffffffc0012766:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc001276b:	be 00 10 00 00       	mov    esi,0x1000
ffffffffc0012770:	e8 db ef ff ff       	call   ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>
ffffffffc0012775:	48 85 c0             	test   rax,rax
ffffffffc0012778:	0f 85 25 05 00 00    	jne    ffffffffc0012ca3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5f3>
ffffffffc001277e:	49 89 d6             	mov    r14,rdx
ffffffffc0012781:	48 b8 00 00 00 00 00 	movabs rax,0x800000000000
ffffffffc0012788:	80 00 00 
ffffffffc001278b:	49 01 c6             	add    r14,rax
ffffffffc001278e:	48 b8 00 00 00 00 00 	movabs rax,0xffff800000000000
ffffffffc0012795:	80 ff ff 
ffffffffc0012798:	4c 89 f7             	mov    rdi,r14
ffffffffc001279b:	48 01 c7             	add    rdi,rax
ffffffffc001279e:	0f 80 e5 04 00 00    	jo     ffffffffc0012c89 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5d9>
ffffffffc00127a4:	0f 84 5f 05 00 00    	je     ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc00127aa:	89 f8                	mov    eax,edi
ffffffffc00127ac:	83 e0 07             	and    eax,0x7
ffffffffc00127af:	48 85 c0             	test   rax,rax
ffffffffc00127b2:	0f 85 51 05 00 00    	jne    ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc00127b8:	ba 00 10 00 00       	mov    edx,0x1000
ffffffffc00127bd:	31 f6                	xor    esi,esi
ffffffffc00127bf:	e8 ec 36 00 00       	call   ffffffffc0015eb0 <memset>
ffffffffc00127c4:	48 b8 ff 0f 00 00 00 	movabs rax,0xfff0000000000fff
ffffffffc00127cb:	00 f0 ff 
ffffffffc00127ce:	49 85 c6             	test   r14,rax
ffffffffc00127d1:	0f 85 f2 04 00 00    	jne    ffffffffc0012cc9 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x619>
ffffffffc00127d7:	48 8b 44 24 68       	mov    rax,QWORD PTR [rsp+0x68]
ffffffffc00127dc:	48 8b 4c 24 50       	mov    rcx,QWORD PTR [rsp+0x50]
ffffffffc00127e1:	4c 0b 74 24 58       	or     r14,QWORD PTR [rsp+0x58]
ffffffffc00127e6:	49 83 ce 01          	or     r14,0x1
ffffffffc00127ea:	4c 89 34 c8          	mov    QWORD PTR [rax+rcx*8],r14
ffffffffc00127ee:	48 8b 4c 24 40       	mov    rcx,QWORD PTR [rsp+0x40]
ffffffffc00127f3:	48 39 d9             	cmp    rcx,rbx
ffffffffc00127f6:	0f 8d 14 04 00 00    	jge    ffffffffc0012c10 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x560>
ffffffffc00127fc:	4c 8b 64 24 40       	mov    r12,QWORD PTR [rsp+0x40]
ffffffffc0012801:	48 b8 00 f0 ff ff ff 	movabs rax,0xffffffffff000
ffffffffc0012808:	ff 0f 00 
ffffffffc001280b:	49 21 c6             	and    r14,rax
ffffffffc001280e:	48 b8 00 00 00 00 00 	movabs rax,0xffff800000000000
ffffffffc0012815:	80 ff ff 
ffffffffc0012818:	49 01 c6             	add    r14,rax
ffffffffc001281b:	4c 89 b4 24 88 00 00 	mov    QWORD PTR [rsp+0x88],r14
ffffffffc0012822:	00 
ffffffffc0012823:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001282a:	84 00 00 00 00 00 
ffffffffc0012830:	bf 03 00 00 00       	mov    edi,0x3
ffffffffc0012835:	e8 a6 07 00 00       	call   ffffffffc0012fe0 <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E>
ffffffffc001283a:	49 89 c7             	mov    r15,rax
ffffffffc001283d:	48 83 e8 01          	sub    rax,0x1
ffffffffc0012841:	0f 82 00 04 00 00    	jb     ffffffffc0012c47 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x597>
ffffffffc0012847:	48 89 d9             	mov    rcx,rbx
ffffffffc001284a:	4c 29 e1             	sub    rcx,r12
ffffffffc001284d:	0f 80 0e 04 00 00    	jo     ffffffffc0012c61 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5b1>
ffffffffc0012853:	48 81 c1 00 10 00 00 	add    rcx,0x1000
ffffffffc001285a:	0f 82 0f 04 00 00    	jb     ffffffffc0012c6f <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5bf>
ffffffffc0012860:	ba 1e 09 00 00       	mov    edx,0x91e
ffffffffc0012865:	48 ff c9             	dec    rcx
ffffffffc0012868:	4c 89 64 24 70       	mov    QWORD PTR [rsp+0x70],r12
ffffffffc001286d:	4c 89 bc 24 90 00 00 	mov    QWORD PTR [rsp+0x90],r15
ffffffffc0012874:	00 
ffffffffc0012875:	c4 c2 e8 f7 d4       	bextr  rdx,r12,rdx
ffffffffc001287a:	48 89 54 24 48       	mov    QWORD PTR [rsp+0x48],rdx
ffffffffc001287f:	4c 39 f9             	cmp    rcx,r15
ffffffffc0012882:	72 6c                	jb     ffffffffc00128f0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x240>
ffffffffc0012884:	4c 21 e0             	and    rax,r12
ffffffffc0012887:	75 67                	jne    ffffffffc00128f0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x240>
ffffffffc0012889:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc001288e:	4c 89 fe             	mov    rsi,r15
ffffffffc0012891:	e8 ba ee ff ff       	call   ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>
ffffffffc0012896:	48 85 c0             	test   rax,rax
ffffffffc0012899:	0f 85 04 04 00 00    	jne    ffffffffc0012ca3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5f3>
ffffffffc001289f:	48 b8 00 00 00 00 00 	movabs rax,0x800000000000
ffffffffc00128a6:	80 00 00 
ffffffffc00128a9:	48 b9 ff 0f 00 00 00 	movabs rcx,0xfff0000000000fff
ffffffffc00128b0:	00 f0 ff 
ffffffffc00128b3:	48 01 c2             	add    rdx,rax
ffffffffc00128b6:	48 85 ca             	test   rdx,rcx
ffffffffc00128b9:	0f 85 0a 04 00 00    	jne    ffffffffc0012cc9 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x619>
ffffffffc00128bf:	48 0b 54 24 60       	or     rdx,QWORD PTR [rsp+0x60]
ffffffffc00128c4:	b8 01 10 00 00       	mov    eax,0x1001
ffffffffc00128c9:	b9 81 00 00 00       	mov    ecx,0x81
ffffffffc00128ce:	f6 c2 80             	test   dl,0x80
ffffffffc00128d1:	48 0f 44 c1          	cmove  rax,rcx
ffffffffc00128d5:	48 8b 4c 24 48       	mov    rcx,QWORD PTR [rsp+0x48]
ffffffffc00128da:	48 09 d0             	or     rax,rdx
ffffffffc00128dd:	49 89 04 ce          	mov    QWORD PTR [r14+rcx*8],rax
ffffffffc00128e1:	e9 fa 02 00 00       	jmp    ffffffffc0012be0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x530>
ffffffffc00128e6:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc00128ed:	00 00 00 
ffffffffc00128f0:	48 8b 44 24 48       	mov    rax,QWORD PTR [rsp+0x48]
ffffffffc00128f5:	4d 8b 2c c6          	mov    r13,QWORD PTR [r14+rax*8]
ffffffffc00128f9:	41 f6 c5 01          	test   r13b,0x1
ffffffffc00128fd:	0f 85 83 00 00 00    	jne    ffffffffc0012986 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x2d6>
ffffffffc0012903:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc0012908:	be 00 10 00 00       	mov    esi,0x1000
ffffffffc001290d:	e8 3e ee ff ff       	call   ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>
ffffffffc0012912:	48 85 c0             	test   rax,rax
ffffffffc0012915:	0f 85 88 03 00 00    	jne    ffffffffc0012ca3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5f3>
ffffffffc001291b:	49 89 d5             	mov    r13,rdx
ffffffffc001291e:	48 b8 00 00 00 00 00 	movabs rax,0x800000000000
ffffffffc0012925:	80 00 00 
ffffffffc0012928:	49 01 c5             	add    r13,rax
ffffffffc001292b:	48 b8 00 00 00 00 00 	movabs rax,0xffff800000000000
ffffffffc0012932:	80 ff ff 
ffffffffc0012935:	4c 89 ef             	mov    rdi,r13
ffffffffc0012938:	48 01 c7             	add    rdi,rax
ffffffffc001293b:	0f 80 48 03 00 00    	jo     ffffffffc0012c89 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5d9>
ffffffffc0012941:	0f 84 c2 03 00 00    	je     ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc0012947:	89 f8                	mov    eax,edi
ffffffffc0012949:	83 e0 07             	and    eax,0x7
ffffffffc001294c:	48 85 c0             	test   rax,rax
ffffffffc001294f:	0f 85 b4 03 00 00    	jne    ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc0012955:	ba 00 10 00 00       	mov    edx,0x1000
ffffffffc001295a:	31 f6                	xor    esi,esi
ffffffffc001295c:	e8 4f 35 00 00       	call   ffffffffc0015eb0 <memset>
ffffffffc0012961:	48 b8 ff 0f 00 00 00 	movabs rax,0xfff0000000000fff
ffffffffc0012968:	00 f0 ff 
ffffffffc001296b:	49 85 c5             	test   r13,rax
ffffffffc001296e:	0f 85 55 03 00 00    	jne    ffffffffc0012cc9 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x619>
ffffffffc0012974:	48 8b 44 24 48       	mov    rax,QWORD PTR [rsp+0x48]
ffffffffc0012979:	4c 0b 6c 24 58       	or     r13,QWORD PTR [rsp+0x58]
ffffffffc001297e:	49 83 cd 01          	or     r13,0x1
ffffffffc0012982:	4d 89 2c c6          	mov    QWORD PTR [r14+rax*8],r13
ffffffffc0012986:	49 39 dc             	cmp    r12,rbx
ffffffffc0012989:	0f 8d 51 02 00 00    	jge    ffffffffc0012be0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x530>
ffffffffc001298f:	4c 8b 74 24 70       	mov    r14,QWORD PTR [rsp+0x70]
ffffffffc0012994:	48 b8 00 f0 ff ff ff 	movabs rax,0xffffffffff000
ffffffffc001299b:	ff 0f 00 
ffffffffc001299e:	49 21 c5             	and    r13,rax
ffffffffc00129a1:	48 b8 00 00 00 00 00 	movabs rax,0xffff800000000000
ffffffffc00129a8:	80 ff ff 
ffffffffc00129ab:	49 01 c5             	add    r13,rax
ffffffffc00129ae:	4c 89 ac 24 98 00 00 	mov    QWORD PTR [rsp+0x98],r13
ffffffffc00129b5:	00 
ffffffffc00129b6:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc00129bd:	00 00 00 
ffffffffc00129c0:	bf 02 00 00 00       	mov    edi,0x2
ffffffffc00129c5:	e8 16 06 00 00       	call   ffffffffc0012fe0 <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E>
ffffffffc00129ca:	49 89 c7             	mov    r15,rax
ffffffffc00129cd:	48 83 e8 01          	sub    rax,0x1
ffffffffc00129d1:	0f 82 70 02 00 00    	jb     ffffffffc0012c47 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x597>
ffffffffc00129d7:	48 89 d9             	mov    rcx,rbx
ffffffffc00129da:	4c 29 f1             	sub    rcx,r14
ffffffffc00129dd:	0f 80 7e 02 00 00    	jo     ffffffffc0012c61 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5b1>
ffffffffc00129e3:	48 81 c1 00 10 00 00 	add    rcx,0x1000
ffffffffc00129ea:	0f 82 7f 02 00 00    	jb     ffffffffc0012c6f <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5bf>
ffffffffc00129f0:	ba 15 09 00 00       	mov    edx,0x915
ffffffffc00129f5:	48 ff c9             	dec    rcx
ffffffffc00129f8:	c4 c2 68 f7 ee       	bextr  ebp,r14d,edx
ffffffffc00129fd:	48 89 ac 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rbp
ffffffffc0012a04:	00 
ffffffffc0012a05:	4c 39 f9             	cmp    rcx,r15
ffffffffc0012a08:	72 66                	jb     ffffffffc0012a70 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x3c0>
ffffffffc0012a0a:	4c 21 f0             	and    rax,r14
ffffffffc0012a0d:	75 61                	jne    ffffffffc0012a70 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x3c0>
ffffffffc0012a0f:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc0012a14:	4c 89 fe             	mov    rsi,r15
ffffffffc0012a17:	e8 34 ed ff ff       	call   ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>
ffffffffc0012a1c:	48 85 c0             	test   rax,rax
ffffffffc0012a1f:	0f 85 7e 02 00 00    	jne    ffffffffc0012ca3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5f3>
ffffffffc0012a25:	48 b8 00 00 00 00 00 	movabs rax,0x800000000000
ffffffffc0012a2c:	80 00 00 
ffffffffc0012a2f:	48 b9 ff 0f 00 00 00 	movabs rcx,0xfff0000000000fff
ffffffffc0012a36:	00 f0 ff 
ffffffffc0012a39:	48 01 c2             	add    rdx,rax
ffffffffc0012a3c:	48 85 ca             	test   rdx,rcx
ffffffffc0012a3f:	0f 85 84 02 00 00    	jne    ffffffffc0012cc9 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x619>
ffffffffc0012a45:	48 0b 54 24 60       	or     rdx,QWORD PTR [rsp+0x60]
ffffffffc0012a4a:	b8 01 10 00 00       	mov    eax,0x1001
ffffffffc0012a4f:	b9 81 00 00 00       	mov    ecx,0x81
ffffffffc0012a54:	f6 c2 80             	test   dl,0x80
ffffffffc0012a57:	48 0f 44 c1          	cmove  rax,rcx
ffffffffc0012a5b:	48 09 d0             	or     rax,rdx
ffffffffc0012a5e:	49 89 44 ed 00       	mov    QWORD PTR [r13+rbp*8+0x0],rax
ffffffffc0012a63:	e9 48 01 00 00       	jmp    ffffffffc0012bb0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x500>
ffffffffc0012a68:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0012a6f:	00 
ffffffffc0012a70:	4d 8b 64 ed 00       	mov    r12,QWORD PTR [r13+rbp*8+0x0]
ffffffffc0012a75:	41 f6 c4 01          	test   r12b,0x1
ffffffffc0012a79:	75 7f                	jne    ffffffffc0012afa <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x44a>
ffffffffc0012a7b:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc0012a80:	be 00 10 00 00       	mov    esi,0x1000
ffffffffc0012a85:	e8 c6 ec ff ff       	call   ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>
ffffffffc0012a8a:	48 85 c0             	test   rax,rax
ffffffffc0012a8d:	0f 85 10 02 00 00    	jne    ffffffffc0012ca3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5f3>
ffffffffc0012a93:	49 89 d4             	mov    r12,rdx
ffffffffc0012a96:	48 b8 00 00 00 00 00 	movabs rax,0x800000000000
ffffffffc0012a9d:	80 00 00 
ffffffffc0012aa0:	49 01 c4             	add    r12,rax
ffffffffc0012aa3:	48 b8 00 00 00 00 00 	movabs rax,0xffff800000000000
ffffffffc0012aaa:	80 ff ff 
ffffffffc0012aad:	4c 89 e7             	mov    rdi,r12
ffffffffc0012ab0:	48 01 c7             	add    rdi,rax
ffffffffc0012ab3:	0f 80 d0 01 00 00    	jo     ffffffffc0012c89 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5d9>
ffffffffc0012ab9:	0f 84 4a 02 00 00    	je     ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc0012abf:	89 f8                	mov    eax,edi
ffffffffc0012ac1:	83 e0 07             	and    eax,0x7
ffffffffc0012ac4:	48 85 c0             	test   rax,rax
ffffffffc0012ac7:	0f 85 3c 02 00 00    	jne    ffffffffc0012d09 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x659>
ffffffffc0012acd:	ba 00 10 00 00       	mov    edx,0x1000
ffffffffc0012ad2:	31 f6                	xor    esi,esi
ffffffffc0012ad4:	e8 d7 33 00 00       	call   ffffffffc0015eb0 <memset>
ffffffffc0012ad9:	48 b8 ff 0f 00 00 00 	movabs rax,0xfff0000000000fff
ffffffffc0012ae0:	00 f0 ff 
ffffffffc0012ae3:	49 85 c4             	test   r12,rax
ffffffffc0012ae6:	0f 85 dd 01 00 00    	jne    ffffffffc0012cc9 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x619>
ffffffffc0012aec:	4c 0b 64 24 58       	or     r12,QWORD PTR [rsp+0x58]
ffffffffc0012af1:	49 83 cc 01          	or     r12,0x1
ffffffffc0012af5:	4d 89 64 ed 00       	mov    QWORD PTR [r13+rbp*8+0x0],r12
ffffffffc0012afa:	49 39 de             	cmp    r14,rbx
ffffffffc0012afd:	0f 8d ad 00 00 00    	jge    ffffffffc0012bb0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x500>
ffffffffc0012b03:	48 b8 00 f0 ff ff ff 	movabs rax,0xffffffffff000
ffffffffc0012b0a:	ff 0f 00 
ffffffffc0012b0d:	48 b9 00 00 00 00 00 	movabs rcx,0xffff800000000000
ffffffffc0012b14:	80 ff ff 
ffffffffc0012b17:	4d 89 f5             	mov    r13,r14
ffffffffc0012b1a:	49 21 c4             	and    r12,rax
ffffffffc0012b1d:	49 01 cc             	add    r12,rcx
ffffffffc0012b20:	bf 01 00 00 00       	mov    edi,0x1
ffffffffc0012b25:	e8 b6 04 00 00       	call   ffffffffc0012fe0 <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E>
ffffffffc0012b2a:	48 85 c0             	test   rax,rax
ffffffffc0012b2d:	0f 84 14 01 00 00    	je     ffffffffc0012c47 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x597>
ffffffffc0012b33:	48 89 c5             	mov    rbp,rax
ffffffffc0012b36:	48 89 d8             	mov    rax,rbx
ffffffffc0012b39:	4c 29 e8             	sub    rax,r13
ffffffffc0012b3c:	0f 80 1f 01 00 00    	jo     ffffffffc0012c61 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5b1>
ffffffffc0012b42:	48 3d ff ef ff ff    	cmp    rax,0xffffffffffffefff
ffffffffc0012b48:	0f 87 21 01 00 00    	ja     ffffffffc0012c6f <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5bf>
ffffffffc0012b4e:	48 8b 7c 24 08       	mov    rdi,QWORD PTR [rsp+0x8]
ffffffffc0012b53:	48 89 ee             	mov    rsi,rbp
ffffffffc0012b56:	e8 f5 eb ff ff       	call   ffffffffc0011750 <_ZN9libkernel4memm6talloc6Talloc5alloc17h6da6ddf735c77216E>
ffffffffc0012b5b:	48 85 c0             	test   rax,rax
ffffffffc0012b5e:	0f 85 3f 01 00 00    	jne    ffffffffc0012ca3 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5f3>
ffffffffc0012b64:	48 b8 00 00 00 00 00 	movabs rax,0x800000000000
ffffffffc0012b6b:	80 00 00 
ffffffffc0012b6e:	48 b9 ff 0f 00 00 00 	movabs rcx,0xfff0000000000fff
ffffffffc0012b75:	00 f0 ff 
ffffffffc0012b78:	48 01 c2             	add    rdx,rax
ffffffffc0012b7b:	48 85 ca             	test   rdx,rcx
ffffffffc0012b7e:	0f 85 45 01 00 00    	jne    ffffffffc0012cc9 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x619>
ffffffffc0012b84:	48 0b 54 24 60       	or     rdx,QWORD PTR [rsp+0x60]
ffffffffc0012b89:	b8 0c 09 00 00       	mov    eax,0x90c
ffffffffc0012b8e:	c4 c2 78 f7 c5       	bextr  eax,r13d,eax
ffffffffc0012b93:	48 83 ca 01          	or     rdx,0x1
ffffffffc0012b97:	49 89 14 c4          	mov    QWORD PTR [r12+rax*8],rdx
ffffffffc0012b9b:	48 3d ff 01 00 00    	cmp    rax,0x1ff
ffffffffc0012ba1:	74 0d                	je     ffffffffc0012bb0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x500>
ffffffffc0012ba3:	49 01 ed             	add    r13,rbp
ffffffffc0012ba6:	49 39 dd             	cmp    r13,rbx
ffffffffc0012ba9:	0f 8c 71 ff ff ff    	jl     ffffffffc0012b20 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x470>
ffffffffc0012baf:	90                   	nop
ffffffffc0012bb0:	4c 8b ac 24 98 00 00 	mov    r13,QWORD PTR [rsp+0x98]
ffffffffc0012bb7:	00 
ffffffffc0012bb8:	81 bc 24 a0 00 00 00 	cmp    DWORD PTR [rsp+0xa0],0x1ff
ffffffffc0012bbf:	ff 01 00 00 
ffffffffc0012bc3:	74 1b                	je     ffffffffc0012be0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x530>
ffffffffc0012bc5:	4d 01 fe             	add    r14,r15
ffffffffc0012bc8:	49 39 de             	cmp    r14,rbx
ffffffffc0012bcb:	0f 8c ef fd ff ff    	jl     ffffffffc00129c0 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x310>
ffffffffc0012bd1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0012bd8:	0f 1f 84 00 00 00 00 
ffffffffc0012bdf:	00 
ffffffffc0012be0:	4c 8b b4 24 88 00 00 	mov    r14,QWORD PTR [rsp+0x88]
ffffffffc0012be7:	00 
ffffffffc0012be8:	4c 8b 64 24 70       	mov    r12,QWORD PTR [rsp+0x70]
ffffffffc0012bed:	81 7c 24 48 ff 01 00 	cmp    DWORD PTR [rsp+0x48],0x1ff
ffffffffc0012bf4:	00 
ffffffffc0012bf5:	74 19                	je     ffffffffc0012c10 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x560>
ffffffffc0012bf7:	4c 03 a4 24 90 00 00 	add    r12,QWORD PTR [rsp+0x90]
ffffffffc0012bfe:	00 
ffffffffc0012bff:	49 39 dc             	cmp    r12,rbx
ffffffffc0012c02:	0f 8c 28 fc ff ff    	jl     ffffffffc0012830 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x180>
ffffffffc0012c08:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0012c0f:	00 
ffffffffc0012c10:	4c 8b 4c 24 78       	mov    r9,QWORD PTR [rsp+0x78]
ffffffffc0012c15:	48 8b 7c 24 40       	mov    rdi,QWORD PTR [rsp+0x40]
ffffffffc0012c1a:	81 7c 24 50 ff 01 00 	cmp    DWORD PTR [rsp+0x50],0x1ff
ffffffffc0012c21:	00 
ffffffffc0012c22:	74 11                	je     ffffffffc0012c35 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x585>
ffffffffc0012c24:	48 03 bc 24 80 00 00 	add    rdi,QWORD PTR [rsp+0x80]
ffffffffc0012c2b:	00 
ffffffffc0012c2c:	48 39 df             	cmp    rdi,rbx
ffffffffc0012c2f:	0f 8c c0 fa ff ff    	jl     ffffffffc00126f5 <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x45>
ffffffffc0012c35:	48 81 c4 a8 00 00 00 	add    rsp,0xa8
ffffffffc0012c3c:	5b                   	pop    rbx
ffffffffc0012c3d:	41 5c                	pop    r12
ffffffffc0012c3f:	41 5d                	pop    r13
ffffffffc0012c41:	41 5e                	pop    r14
ffffffffc0012c43:	41 5f                	pop    r15
ffffffffc0012c45:	5d                   	pop    rbp
ffffffffc0012c46:	c3                   	ret    
ffffffffc0012c47:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0012c4c:	48 c7 c7 60 72 01 c0 	mov    rdi,0xffffffffc0017260
ffffffffc0012c53:	48 c7 c2 48 72 01 c0 	mov    rdx,0xffffffffc0017248
ffffffffc0012c5a:	e8 d1 19 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0012c5f:	0f 0b                	ud2    
ffffffffc0012c61:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0012c66:	48 c7 c7 60 72 01 c0 	mov    rdi,0xffffffffc0017260
ffffffffc0012c6d:	eb 0c                	jmp    ffffffffc0012c7b <_ZN9libkernel4memm10map_offset17h6d1e72d888d03e32E+0x5cb>
ffffffffc0012c6f:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0012c74:	48 c7 c7 80 71 01 c0 	mov    rdi,0xffffffffc0017180
ffffffffc0012c7b:	48 c7 c2 88 72 01 c0 	mov    rdx,0xffffffffc0017288
ffffffffc0012c82:	e8 a9 19 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0012c87:	0f 0b                	ud2    
ffffffffc0012c89:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0012c8e:	48 c7 c7 80 71 01 c0 	mov    rdi,0xffffffffc0017180
ffffffffc0012c95:	48 c7 c2 a0 72 01 c0 	mov    rdx,0xffffffffc00172a0
ffffffffc0012c9c:	e8 8f 19 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0012ca1:	0f 0b                	ud2    
ffffffffc0012ca3:	48 8d 54 24 10       	lea    rdx,[rsp+0x10]
ffffffffc0012ca8:	be 27 00 00 00       	mov    esi,0x27
ffffffffc0012cad:	48 c7 c7 ae 70 01 c0 	mov    rdi,0xffffffffc00170ae
ffffffffc0012cb4:	48 c7 c1 60 70 01 c0 	mov    rcx,0xffffffffc0017060
ffffffffc0012cbb:	49 c7 c0 d8 70 01 c0 	mov    r8,0xffffffffc00170d8
ffffffffc0012cc2:	e8 b9 21 00 00       	call   ffffffffc0014e80 <_ZN4core6result13unwrap_failed17he47b8d70f74ecda1E>
ffffffffc0012cc7:	0f 0b                	ud2    
ffffffffc0012cc9:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc0012cce:	48 c7 c6 18 72 01 c0 	mov    rsi,0xffffffffc0017218
ffffffffc0012cd5:	48 c7 44 24 10 08 72 	mov    QWORD PTR [rsp+0x10],0xffffffffc0017208
ffffffffc0012cdc:	01 c0 
ffffffffc0012cde:	48 c7 44 24 18 01 00 	mov    QWORD PTR [rsp+0x18],0x1
ffffffffc0012ce5:	00 00 
ffffffffc0012ce7:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
ffffffffc0012cee:	00 00 
ffffffffc0012cf0:	48 c7 44 24 30 a0 71 	mov    QWORD PTR [rsp+0x30],0xffffffffc00171a0
ffffffffc0012cf7:	01 c0 
ffffffffc0012cf9:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
ffffffffc0012d00:	00 00 
ffffffffc0012d02:	e8 f9 19 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0012d07:	0f 0b                	ud2    
ffffffffc0012d09:	0f 0b                	ud2    
ffffffffc0012d0b:	0f 0b                	ud2    
ffffffffc0012d0d:	cc                   	int3   
ffffffffc0012d0e:	cc                   	int3   
ffffffffc0012d0f:	cc                   	int3   

ffffffffc0012d10 <_ZN52_$LT$$BP$mut$u20$T$u20$as$u20$core..fmt..Pointer$GT$3fmt17hf9c02e0d3df6cf06E>:
ffffffffc0012d10:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
ffffffffc0012d13:	e9 68 16 00 00       	jmp    ffffffffc0014380 <_ZN54_$LT$$BP$const$u20$T$u20$as$u20$core..fmt..Pointer$GT$3fmt5inner17hdd56e846e6855501E>
ffffffffc0012d18:	cc                   	int3   
ffffffffc0012d19:	cc                   	int3   
ffffffffc0012d1a:	cc                   	int3   
ffffffffc0012d1b:	cc                   	int3   
ffffffffc0012d1c:	cc                   	int3   
ffffffffc0012d1d:	cc                   	int3   
ffffffffc0012d1e:	cc                   	int3   
ffffffffc0012d1f:	cc                   	int3   

ffffffffc0012d20 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E>:
ffffffffc0012d20:	41 56                	push   r14
ffffffffc0012d22:	53                   	push   rbx
ffffffffc0012d23:	48 83 ec 38          	sub    rsp,0x38
ffffffffc0012d27:	49 89 fe             	mov    r14,rdi
ffffffffc0012d2a:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0012d2f:	48 c7 c7 c0 95 01 c0 	mov    rdi,0xffffffffc00195c0
ffffffffc0012d36:	48 c7 44 24 08 b8 95 	mov    QWORD PTR [rsp+0x8],0xffffffffc00195b8
ffffffffc0012d3d:	01 c0 
ffffffffc0012d3f:	e8 ac f5 ff ff       	call   ffffffffc00122f0 <_ZN4spin4once17Once$LT$T$C$R$GT$9call_once17h6135ecab0716257eE>
ffffffffc0012d44:	48 89 c3             	mov    rbx,rax
ffffffffc0012d47:	b1 01                	mov    cl,0x1
ffffffffc0012d49:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc0012d50:	31 c0                	xor    eax,eax
ffffffffc0012d52:	f0 0f b0 0b          	lock cmpxchg BYTE PTR [rbx],cl
ffffffffc0012d56:	74 09                	je     ffffffffc0012d61 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E+0x41>
ffffffffc0012d58:	0f b6 03             	movzx  eax,BYTE PTR [rbx]
ffffffffc0012d5b:	84 c0                	test   al,al
ffffffffc0012d5d:	75 f9                	jne    ffffffffc0012d58 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E+0x38>
ffffffffc0012d5f:	eb ef                	jmp    ffffffffc0012d50 <_ZN9libkernel3out7__print17hd4cd7ad9d39f0369E+0x30>
ffffffffc0012d61:	49 8b 4e 20          	mov    rcx,QWORD PTR [r14+0x20]
ffffffffc0012d65:	49 8b 56 28          	mov    rdx,QWORD PTR [r14+0x28]
ffffffffc0012d69:	48 89 d8             	mov    rax,rbx
ffffffffc0012d6c:	48 89 e7             	mov    rdi,rsp
ffffffffc0012d6f:	48 c7 c6 08 6e 01 c0 	mov    rsi,0xffffffffc0016e08
ffffffffc0012d76:	48 83 c0 02          	add    rax,0x2
ffffffffc0012d7a:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc0012d7e:	49 8b 06             	mov    rax,QWORD PTR [r14]
ffffffffc0012d81:	48 89 4c 24 28       	mov    QWORD PTR [rsp+0x28],rcx
ffffffffc0012d86:	49 8b 4e 10          	mov    rcx,QWORD PTR [r14+0x10]
ffffffffc0012d8a:	48 89 54 24 30       	mov    QWORD PTR [rsp+0x30],rdx
ffffffffc0012d8f:	49 8b 56 18          	mov    rdx,QWORD PTR [r14+0x18]
ffffffffc0012d93:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
ffffffffc0012d98:	48 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],rcx
ffffffffc0012d9d:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
ffffffffc0012da1:	48 89 54 24 20       	mov    QWORD PTR [rsp+0x20],rdx
ffffffffc0012da6:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0012dab:	48 89 4c 24 10       	mov    QWORD PTR [rsp+0x10],rcx
ffffffffc0012db0:	e8 4b 05 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0012db5:	c6 03 00             	mov    BYTE PTR [rbx],0x0
ffffffffc0012db8:	48 83 c4 38          	add    rsp,0x38
ffffffffc0012dbc:	5b                   	pop    rbx
ffffffffc0012dbd:	41 5e                	pop    r14
ffffffffc0012dbf:	c3                   	ret    

ffffffffc0012dc0 <_ZN4core3ptr30drop_in_place$LT$$RF$usize$GT$17hfdcc02010c398ff3E.llvm.13672949638510867836>:
ffffffffc0012dc0:	c3                   	ret    
ffffffffc0012dc1:	cc                   	int3   
ffffffffc0012dc2:	cc                   	int3   
ffffffffc0012dc3:	cc                   	int3   
ffffffffc0012dc4:	cc                   	int3   
ffffffffc0012dc5:	cc                   	int3   
ffffffffc0012dc6:	cc                   	int3   
ffffffffc0012dc7:	cc                   	int3   
ffffffffc0012dc8:	cc                   	int3   
ffffffffc0012dc9:	cc                   	int3   
ffffffffc0012dca:	cc                   	int3   
ffffffffc0012dcb:	cc                   	int3   
ffffffffc0012dcc:	cc                   	int3   
ffffffffc0012dcd:	cc                   	int3   
ffffffffc0012dce:	cc                   	int3   
ffffffffc0012dcf:	cc                   	int3   

ffffffffc0012dd0 <_ZN4core9panicking13assert_failed17hee52879969419ac6E>:
ffffffffc0012dd0:	48 83 ec 48          	sub    rsp,0x48
ffffffffc0012dd4:	48 89 74 24 08       	mov    QWORD PTR [rsp+0x8],rsi
ffffffffc0012dd9:	48 89 54 24 10       	mov    QWORD PTR [rsp+0x10],rdx
ffffffffc0012dde:	48 8b 71 20          	mov    rsi,QWORD PTR [rcx+0x20]
ffffffffc0012de2:	48 8b 51 18          	mov    rdx,QWORD PTR [rcx+0x18]
ffffffffc0012de6:	48 8b 41 28          	mov    rax,QWORD PTR [rcx+0x28]
ffffffffc0012dea:	4c 89 04 24          	mov    QWORD PTR [rsp],r8
ffffffffc0012dee:	4c 8d 4c 24 18       	lea    r9,[rsp+0x18]
ffffffffc0012df3:	49 c7 c0 b8 72 01 c0 	mov    r8,0xffffffffc00172b8
ffffffffc0012dfa:	48 89 74 24 38       	mov    QWORD PTR [rsp+0x38],rsi
ffffffffc0012dff:	48 89 54 24 30       	mov    QWORD PTR [rsp+0x30],rdx
ffffffffc0012e04:	48 8b 71 10          	mov    rsi,QWORD PTR [rcx+0x10]
ffffffffc0012e08:	48 8b 11             	mov    rdx,QWORD PTR [rcx]
ffffffffc0012e0b:	48 8b 49 08          	mov    rcx,QWORD PTR [rcx+0x8]
ffffffffc0012e0f:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
ffffffffc0012e14:	48 89 74 24 28       	mov    QWORD PTR [rsp+0x28],rsi
ffffffffc0012e19:	48 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],rcx
ffffffffc0012e1e:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
ffffffffc0012e23:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0012e28:	48 8d 4c 24 10       	lea    rcx,[rsp+0x10]
ffffffffc0012e2d:	48 c7 c2 b8 72 01 c0 	mov    rdx,0xffffffffc00172b8
ffffffffc0012e34:	e8 f7 18 00 00       	call   ffffffffc0014730 <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E>
ffffffffc0012e39:	0f 0b                	ud2    
ffffffffc0012e3b:	cc                   	int3   
ffffffffc0012e3c:	cc                   	int3   
ffffffffc0012e3d:	cc                   	int3   
ffffffffc0012e3e:	cc                   	int3   
ffffffffc0012e3f:	cc                   	int3   

ffffffffc0012e40 <_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hbc2bb25c6221548aE>:
ffffffffc0012e40:	41 56                	push   r14
ffffffffc0012e42:	53                   	push   rbx
ffffffffc0012e43:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0012e47:	4c 8b 37             	mov    r14,QWORD PTR [rdi]
ffffffffc0012e4a:	48 89 f7             	mov    rdi,rsi
ffffffffc0012e4d:	48 89 f3             	mov    rbx,rsi
ffffffffc0012e50:	e8 6b 0e 00 00       	call   ffffffffc0013cc0 <_ZN4core3fmt9Formatter15debug_lower_hex17h6865ac6c69cda674E>
ffffffffc0012e55:	84 c0                	test   al,al
ffffffffc0012e57:	74 12                	je     ffffffffc0012e6b <_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hbc2bb25c6221548aE+0x2b>
ffffffffc0012e59:	4c 89 f7             	mov    rdi,r14
ffffffffc0012e5c:	48 89 de             	mov    rsi,rbx
ffffffffc0012e5f:	48 83 c4 08          	add    rsp,0x8
ffffffffc0012e63:	5b                   	pop    rbx
ffffffffc0012e64:	41 5e                	pop    r14
ffffffffc0012e66:	e9 f5 02 00 00       	jmp    ffffffffc0013160 <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i64$GT$3fmt17he365d173729e9b58E>
ffffffffc0012e6b:	48 89 df             	mov    rdi,rbx
ffffffffc0012e6e:	e8 5d 0e 00 00       	call   ffffffffc0013cd0 <_ZN4core3fmt9Formatter15debug_upper_hex17h9fa440d285b51edeE>
ffffffffc0012e73:	4c 89 f7             	mov    rdi,r14
ffffffffc0012e76:	48 89 de             	mov    rsi,rbx
ffffffffc0012e79:	48 83 c4 08          	add    rsp,0x8
ffffffffc0012e7d:	84 c0                	test   al,al
ffffffffc0012e7f:	74 08                	je     ffffffffc0012e89 <_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hbc2bb25c6221548aE+0x49>
ffffffffc0012e81:	5b                   	pop    rbx
ffffffffc0012e82:	41 5e                	pop    r14
ffffffffc0012e84:	e9 67 03 00 00       	jmp    ffffffffc00131f0 <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i64$GT$3fmt17h85d8853bf1cde852E>
ffffffffc0012e89:	5b                   	pop    rbx
ffffffffc0012e8a:	41 5e                	pop    r14
ffffffffc0012e8c:	e9 7f 25 00 00       	jmp    ffffffffc0015410 <_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u64$GT$3fmt17hf1643dd746945879E>
ffffffffc0012e91:	cc                   	int3   
ffffffffc0012e92:	cc                   	int3   
ffffffffc0012e93:	cc                   	int3   
ffffffffc0012e94:	cc                   	int3   
ffffffffc0012e95:	cc                   	int3   
ffffffffc0012e96:	cc                   	int3   
ffffffffc0012e97:	cc                   	int3   
ffffffffc0012e98:	cc                   	int3   
ffffffffc0012e99:	cc                   	int3   
ffffffffc0012e9a:	cc                   	int3   
ffffffffc0012e9b:	cc                   	int3   
ffffffffc0012e9c:	cc                   	int3   
ffffffffc0012e9d:	cc                   	int3   
ffffffffc0012e9e:	cc                   	int3   
ffffffffc0012e9f:	cc                   	int3   

ffffffffc0012ea0 <_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hc4274b44457bef16E>:
ffffffffc0012ea0:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0012ea3:	48 89 f2             	mov    rdx,rsi
ffffffffc0012ea6:	48 8b 77 08          	mov    rsi,QWORD PTR [rdi+0x8]
ffffffffc0012eaa:	48 89 c7             	mov    rdi,rax
ffffffffc0012ead:	e9 2e 0e 00 00       	jmp    ffffffffc0013ce0 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E>
ffffffffc0012eb2:	cc                   	int3   
ffffffffc0012eb3:	cc                   	int3   
ffffffffc0012eb4:	cc                   	int3   
ffffffffc0012eb5:	cc                   	int3   
ffffffffc0012eb6:	cc                   	int3   
ffffffffc0012eb7:	cc                   	int3   
ffffffffc0012eb8:	cc                   	int3   
ffffffffc0012eb9:	cc                   	int3   
ffffffffc0012eba:	cc                   	int3   
ffffffffc0012ebb:	cc                   	int3   
ffffffffc0012ebc:	cc                   	int3   
ffffffffc0012ebd:	cc                   	int3   
ffffffffc0012ebe:	cc                   	int3   
ffffffffc0012ebf:	cc                   	int3   

ffffffffc0012ec0 <_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h77e13bccf76b22bcE>:
ffffffffc0012ec0:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0012ec3:	48 89 f2             	mov    rdx,rsi
ffffffffc0012ec6:	48 8b 77 08          	mov    rsi,QWORD PTR [rdi+0x8]
ffffffffc0012eca:	48 89 c7             	mov    rdi,rax
ffffffffc0012ecd:	e9 0e 12 00 00       	jmp    ffffffffc00140e0 <_ZN42_$LT$str$u20$as$u20$core..fmt..Display$GT$3fmt17h779539b9b1a83356E>
ffffffffc0012ed2:	cc                   	int3   
ffffffffc0012ed3:	cc                   	int3   
ffffffffc0012ed4:	cc                   	int3   
ffffffffc0012ed5:	cc                   	int3   
ffffffffc0012ed6:	cc                   	int3   
ffffffffc0012ed7:	cc                   	int3   
ffffffffc0012ed8:	cc                   	int3   
ffffffffc0012ed9:	cc                   	int3   
ffffffffc0012eda:	cc                   	int3   
ffffffffc0012edb:	cc                   	int3   
ffffffffc0012edc:	cc                   	int3   
ffffffffc0012edd:	cc                   	int3   
ffffffffc0012ede:	cc                   	int3   
ffffffffc0012edf:	cc                   	int3   

ffffffffc0012ee0 <_ZN4spin4once6status6Status13new_unchecked17h84cb4dc5af5dc742E>:
ffffffffc0012ee0:	89 f8                	mov    eax,edi
ffffffffc0012ee2:	c3                   	ret    
ffffffffc0012ee3:	cc                   	int3   
ffffffffc0012ee4:	cc                   	int3   
ffffffffc0012ee5:	cc                   	int3   
ffffffffc0012ee6:	cc                   	int3   
ffffffffc0012ee7:	cc                   	int3   
ffffffffc0012ee8:	cc                   	int3   
ffffffffc0012ee9:	cc                   	int3   
ffffffffc0012eea:	cc                   	int3   
ffffffffc0012eeb:	cc                   	int3   
ffffffffc0012eec:	cc                   	int3   
ffffffffc0012eed:	cc                   	int3   
ffffffffc0012eee:	cc                   	int3   
ffffffffc0012eef:	cc                   	int3   

ffffffffc0012ef0 <_ZN5amd645ports4out817h22d38ad8fe5d275cE>:
ffffffffc0012ef0:	89 f0                	mov    eax,esi
ffffffffc0012ef2:	89 fa                	mov    edx,edi
ffffffffc0012ef4:	ee                   	out    dx,al
ffffffffc0012ef5:	c3                   	ret    
ffffffffc0012ef6:	cc                   	int3   
ffffffffc0012ef7:	cc                   	int3   
ffffffffc0012ef8:	cc                   	int3   
ffffffffc0012ef9:	cc                   	int3   
ffffffffc0012efa:	cc                   	int3   
ffffffffc0012efb:	cc                   	int3   
ffffffffc0012efc:	cc                   	int3   
ffffffffc0012efd:	cc                   	int3   
ffffffffc0012efe:	cc                   	int3   
ffffffffc0012eff:	cc                   	int3   

ffffffffc0012f00 <_ZN5amd645ports3in817h121ca28f066f0326E>:
ffffffffc0012f00:	89 fa                	mov    edx,edi
ffffffffc0012f02:	ec                   	in     al,dx
ffffffffc0012f03:	c3                   	ret    
ffffffffc0012f04:	cc                   	int3   
ffffffffc0012f05:	cc                   	int3   
ffffffffc0012f06:	cc                   	int3   
ffffffffc0012f07:	cc                   	int3   
ffffffffc0012f08:	cc                   	int3   
ffffffffc0012f09:	cc                   	int3   
ffffffffc0012f0a:	cc                   	int3   
ffffffffc0012f0b:	cc                   	int3   
ffffffffc0012f0c:	cc                   	int3   
ffffffffc0012f0d:	cc                   	int3   
ffffffffc0012f0e:	cc                   	int3   
ffffffffc0012f0f:	cc                   	int3   

ffffffffc0012f10 <_ZN5amd649registers3CR04read17h88cde8e597b97367E>:
ffffffffc0012f10:	0f 20 c0             	mov    rax,cr0
ffffffffc0012f13:	c3                   	ret    
ffffffffc0012f14:	cc                   	int3   
ffffffffc0012f15:	cc                   	int3   
ffffffffc0012f16:	cc                   	int3   
ffffffffc0012f17:	cc                   	int3   
ffffffffc0012f18:	cc                   	int3   
ffffffffc0012f19:	cc                   	int3   
ffffffffc0012f1a:	cc                   	int3   
ffffffffc0012f1b:	cc                   	int3   
ffffffffc0012f1c:	cc                   	int3   
ffffffffc0012f1d:	cc                   	int3   
ffffffffc0012f1e:	cc                   	int3   
ffffffffc0012f1f:	cc                   	int3   

ffffffffc0012f20 <_ZN5amd649registers3CR05write17h996a4ee17b157f79E>:
ffffffffc0012f20:	0f 22 c7             	mov    cr0,rdi
ffffffffc0012f23:	c3                   	ret    
ffffffffc0012f24:	cc                   	int3   
ffffffffc0012f25:	cc                   	int3   
ffffffffc0012f26:	cc                   	int3   
ffffffffc0012f27:	cc                   	int3   
ffffffffc0012f28:	cc                   	int3   
ffffffffc0012f29:	cc                   	int3   
ffffffffc0012f2a:	cc                   	int3   
ffffffffc0012f2b:	cc                   	int3   
ffffffffc0012f2c:	cc                   	int3   
ffffffffc0012f2d:	cc                   	int3   
ffffffffc0012f2e:	cc                   	int3   
ffffffffc0012f2f:	cc                   	int3   

ffffffffc0012f30 <_ZN5amd649registers3CR310set_nflags17hd29ca20d6e88193eE>:
ffffffffc0012f30:	0f 20 e0             	mov    rax,cr4
ffffffffc0012f33:	a9 00 00 02 00       	test   eax,0x20000
ffffffffc0012f38:	74 18                	je     ffffffffc0012f52 <_ZN5amd649registers3CR310set_nflags17hd29ca20d6e88193eE+0x22>
ffffffffc0012f3a:	48 c7 c1 00 fe ff ff 	mov    rcx,0xfffffffffffffe00
ffffffffc0012f41:	0f 20 d8             	mov    rax,cr3
ffffffffc0012f44:	48 21 c8             	and    rax,rcx
ffffffffc0012f47:	0f 22 d8             	mov    cr3,rax
ffffffffc0012f4a:	25 ff 7f f5 01       	and    eax,0x1f57fff
ffffffffc0012f4f:	0f 22 e0             	mov    cr4,rax
ffffffffc0012f52:	0f 22 df             	mov    cr3,rdi
ffffffffc0012f55:	c3                   	ret    
ffffffffc0012f56:	cc                   	int3   
ffffffffc0012f57:	cc                   	int3   
ffffffffc0012f58:	cc                   	int3   
ffffffffc0012f59:	cc                   	int3   
ffffffffc0012f5a:	cc                   	int3   
ffffffffc0012f5b:	cc                   	int3   
ffffffffc0012f5c:	cc                   	int3   
ffffffffc0012f5d:	cc                   	int3   
ffffffffc0012f5e:	cc                   	int3   
ffffffffc0012f5f:	cc                   	int3   

ffffffffc0012f60 <_ZN5amd649registers3CR34read17h27ce5027a3a848dcE>:
ffffffffc0012f60:	0f 20 e1             	mov    rcx,cr4
ffffffffc0012f63:	81 e1 00 00 02 00    	and    ecx,0x20000
ffffffffc0012f69:	48 89 f8             	mov    rax,rdi
ffffffffc0012f6c:	48 be ff 0f 00 00 00 	movabs rsi,0xfff0000000000fff
ffffffffc0012f73:	00 f0 ff 
ffffffffc0012f76:	bf ff 01 00 00       	mov    edi,0x1ff
ffffffffc0012f7b:	48 89 ca             	mov    rdx,rcx
ffffffffc0012f7e:	48 c1 ea 11          	shr    rdx,0x11
ffffffffc0012f82:	48 85 c9             	test   rcx,rcx
ffffffffc0012f85:	0f 20 d9             	mov    rcx,cr3
ffffffffc0012f88:	48 0f 44 fe          	cmove  rdi,rsi
ffffffffc0012f8c:	48 be 00 f0 ff ff ff 	movabs rsi,0xffffffffff000
ffffffffc0012f93:	ff 0f 00 
ffffffffc0012f96:	48 89 10             	mov    QWORD PTR [rax],rdx
ffffffffc0012f99:	48 21 cf             	and    rdi,rcx
ffffffffc0012f9c:	48 21 ce             	and    rsi,rcx
ffffffffc0012f9f:	48 89 78 08          	mov    QWORD PTR [rax+0x8],rdi
ffffffffc0012fa3:	48 89 70 10          	mov    QWORD PTR [rax+0x10],rsi
ffffffffc0012fa7:	c3                   	ret    
ffffffffc0012fa8:	cc                   	int3   
ffffffffc0012fa9:	cc                   	int3   
ffffffffc0012faa:	cc                   	int3   
ffffffffc0012fab:	cc                   	int3   
ffffffffc0012fac:	cc                   	int3   
ffffffffc0012fad:	cc                   	int3   
ffffffffc0012fae:	cc                   	int3   
ffffffffc0012faf:	cc                   	int3   

ffffffffc0012fb0 <_ZN5amd648hlt_loop17hac4b60f2ae618ea8E>:
ffffffffc0012fb0:	f4                   	hlt    
ffffffffc0012fb1:	eb fd                	jmp    ffffffffc0012fb0 <_ZN5amd648hlt_loop17hac4b60f2ae618ea8E>
ffffffffc0012fb3:	cc                   	int3   
ffffffffc0012fb4:	cc                   	int3   
ffffffffc0012fb5:	cc                   	int3   
ffffffffc0012fb6:	cc                   	int3   
ffffffffc0012fb7:	cc                   	int3   
ffffffffc0012fb8:	cc                   	int3   
ffffffffc0012fb9:	cc                   	int3   
ffffffffc0012fba:	cc                   	int3   
ffffffffc0012fbb:	cc                   	int3   
ffffffffc0012fbc:	cc                   	int3   
ffffffffc0012fbd:	cc                   	int3   
ffffffffc0012fbe:	cc                   	int3   
ffffffffc0012fbf:	cc                   	int3   

ffffffffc0012fc0 <_ZN5amd646paging3Pat5write17h0d0070c1f1203b57E>:
ffffffffc0012fc0:	48 89 fa             	mov    rdx,rdi
ffffffffc0012fc3:	48 89 f8             	mov    rax,rdi
ffffffffc0012fc6:	b9 77 02 00 00       	mov    ecx,0x277
ffffffffc0012fcb:	48 c1 ea 20          	shr    rdx,0x20
ffffffffc0012fcf:	0f 30                	wrmsr  
ffffffffc0012fd1:	c3                   	ret    
ffffffffc0012fd2:	cc                   	int3   
ffffffffc0012fd3:	cc                   	int3   
ffffffffc0012fd4:	cc                   	int3   
ffffffffc0012fd5:	cc                   	int3   
ffffffffc0012fd6:	cc                   	int3   
ffffffffc0012fd7:	cc                   	int3   
ffffffffc0012fd8:	cc                   	int3   
ffffffffc0012fd9:	cc                   	int3   
ffffffffc0012fda:	cc                   	int3   
ffffffffc0012fdb:	cc                   	int3   
ffffffffc0012fdc:	cc                   	int3   
ffffffffc0012fdd:	cc                   	int3   
ffffffffc0012fde:	cc                   	int3   
ffffffffc0012fdf:	cc                   	int3   

ffffffffc0012fe0 <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E>:
ffffffffc0012fe0:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0012fe4:	48 89 f8             	mov    rax,rdi
ffffffffc0012fe7:	b9 09 00 00 00       	mov    ecx,0x9
ffffffffc0012fec:	48 f7 e1             	mul    rcx
ffffffffc0012fef:	70 12                	jo     ffffffffc0013003 <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E+0x23>
ffffffffc0012ff1:	48 83 f8 40          	cmp    rax,0x40
ffffffffc0012ff5:	73 26                	jae    ffffffffc001301d <_ZN5amd646paging9page_size17h6b04b0b7a78a3675E+0x3d>
ffffffffc0012ff7:	b9 08 00 00 00       	mov    ecx,0x8
ffffffffc0012ffc:	c4 e2 f9 f7 c1       	shlx   rax,rcx,rax
ffffffffc0013001:	59                   	pop    rcx
ffffffffc0013002:	c3                   	ret    
ffffffffc0013003:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0013008:	48 c7 c7 10 73 01 c0 	mov    rdi,0xffffffffc0017310
ffffffffc001300f:	48 c7 c2 f0 72 01 c0 	mov    rdx,0xffffffffc00172f0
ffffffffc0013016:	e8 15 16 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001301b:	0f 0b                	ud2    
ffffffffc001301d:	be 23 00 00 00       	mov    esi,0x23
ffffffffc0013022:	48 c7 c7 50 73 01 c0 	mov    rdi,0xffffffffc0017350
ffffffffc0013029:	48 c7 c2 38 73 01 c0 	mov    rdx,0xffffffffc0017338
ffffffffc0013030:	e8 fb 15 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0013035:	0f 0b                	ud2    
ffffffffc0013037:	cc                   	int3   
ffffffffc0013038:	cc                   	int3   
ffffffffc0013039:	cc                   	int3   
ffffffffc001303a:	cc                   	int3   
ffffffffc001303b:	cc                   	int3   
ffffffffc001303c:	cc                   	int3   
ffffffffc001303d:	cc                   	int3   
ffffffffc001303e:	cc                   	int3   
ffffffffc001303f:	cc                   	int3   

ffffffffc0013040 <_ZN4core3fmt3num12GenericRadix7fmt_int17h687cf171525b98aaE.llvm.17464636063181802738>:
ffffffffc0013040:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc0013047:	4c 8d 84 24 88 00 00 	lea    r8,[rsp+0x88]
ffffffffc001304e:	00 
ffffffffc001304f:	45 31 c9             	xor    r9d,r9d
ffffffffc0013052:	41 ba 30 00 00 00    	mov    r10d,0x30
ffffffffc0013058:	48 89 f9             	mov    rcx,rdi
ffffffffc001305b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0013060:	89 fa                	mov    edx,edi
ffffffffc0013062:	b8 57 00 00 00       	mov    eax,0x57
ffffffffc0013067:	80 e2 0f             	and    dl,0xf
ffffffffc001306a:	80 fa 0a             	cmp    dl,0xa
ffffffffc001306d:	41 0f 42 c2          	cmovb  eax,r10d
ffffffffc0013071:	48 c1 e9 04          	shr    rcx,0x4
ffffffffc0013075:	49 ff c1             	inc    r9
ffffffffc0013078:	00 d0                	add    al,dl
ffffffffc001307a:	41 88 40 ff          	mov    BYTE PTR [r8-0x1],al
ffffffffc001307e:	49 ff c8             	dec    r8
ffffffffc0013081:	48 83 ff 0f          	cmp    rdi,0xf
ffffffffc0013085:	48 89 cf             	mov    rdi,rcx
ffffffffc0013088:	77 d6                	ja     ffffffffc0013060 <_ZN4core3fmt3num12GenericRadix7fmt_int17h687cf171525b98aaE.llvm.17464636063181802738+0x20>
ffffffffc001308a:	bf 80 00 00 00       	mov    edi,0x80
ffffffffc001308f:	4c 29 cf             	sub    rdi,r9
ffffffffc0013092:	48 81 ff 81 00 00 00 	cmp    rdi,0x81
ffffffffc0013099:	73 21                	jae    ffffffffc00130bc <_ZN4core3fmt3num12GenericRadix7fmt_int17h687cf171525b98aaE.llvm.17464636063181802738+0x7c>
ffffffffc001309b:	48 89 f7             	mov    rdi,rsi
ffffffffc001309e:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc00130a3:	be 01 00 00 00       	mov    esi,0x1
ffffffffc00130a8:	48 c7 c2 00 74 01 c0 	mov    rdx,0xffffffffc0017400
ffffffffc00130af:	e8 dc 04 00 00       	call   ffffffffc0013590 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E>
ffffffffc00130b4:	48 81 c4 88 00 00 00 	add    rsp,0x88
ffffffffc00130bb:	c3                   	ret    
ffffffffc00130bc:	be 80 00 00 00       	mov    esi,0x80
ffffffffc00130c1:	48 c7 c2 e8 73 01 c0 	mov    rdx,0xffffffffc00173e8
ffffffffc00130c8:	e8 43 24 00 00       	call   ffffffffc0015510 <_ZN4core5slice5index26slice_start_index_len_fail17hfbe4f54d0d3768aaE>
ffffffffc00130cd:	0f 0b                	ud2    
ffffffffc00130cf:	cc                   	int3   

ffffffffc00130d0 <_ZN4core3fmt3num12GenericRadix7fmt_int17h8b72c24675466247E.llvm.17464636063181802738>:
ffffffffc00130d0:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc00130d7:	4c 8d 84 24 88 00 00 	lea    r8,[rsp+0x88]
ffffffffc00130de:	00 
ffffffffc00130df:	45 31 c9             	xor    r9d,r9d
ffffffffc00130e2:	41 ba 30 00 00 00    	mov    r10d,0x30
ffffffffc00130e8:	48 89 f9             	mov    rcx,rdi
ffffffffc00130eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00130f0:	89 fa                	mov    edx,edi
ffffffffc00130f2:	b8 37 00 00 00       	mov    eax,0x37
ffffffffc00130f7:	80 e2 0f             	and    dl,0xf
ffffffffc00130fa:	80 fa 0a             	cmp    dl,0xa
ffffffffc00130fd:	41 0f 42 c2          	cmovb  eax,r10d
ffffffffc0013101:	48 c1 e9 04          	shr    rcx,0x4
ffffffffc0013105:	49 ff c1             	inc    r9
ffffffffc0013108:	00 d0                	add    al,dl
ffffffffc001310a:	41 88 40 ff          	mov    BYTE PTR [r8-0x1],al
ffffffffc001310e:	49 ff c8             	dec    r8
ffffffffc0013111:	48 83 ff 0f          	cmp    rdi,0xf
ffffffffc0013115:	48 89 cf             	mov    rdi,rcx
ffffffffc0013118:	77 d6                	ja     ffffffffc00130f0 <_ZN4core3fmt3num12GenericRadix7fmt_int17h8b72c24675466247E.llvm.17464636063181802738+0x20>
ffffffffc001311a:	bf 80 00 00 00       	mov    edi,0x80
ffffffffc001311f:	4c 29 cf             	sub    rdi,r9
ffffffffc0013122:	48 81 ff 81 00 00 00 	cmp    rdi,0x81
ffffffffc0013129:	73 21                	jae    ffffffffc001314c <_ZN4core3fmt3num12GenericRadix7fmt_int17h8b72c24675466247E.llvm.17464636063181802738+0x7c>
ffffffffc001312b:	48 89 f7             	mov    rdi,rsi
ffffffffc001312e:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc0013133:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0013138:	48 c7 c2 00 74 01 c0 	mov    rdx,0xffffffffc0017400
ffffffffc001313f:	e8 4c 04 00 00       	call   ffffffffc0013590 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E>
ffffffffc0013144:	48 81 c4 88 00 00 00 	add    rsp,0x88
ffffffffc001314b:	c3                   	ret    
ffffffffc001314c:	be 80 00 00 00       	mov    esi,0x80
ffffffffc0013151:	48 c7 c2 e8 73 01 c0 	mov    rdx,0xffffffffc00173e8
ffffffffc0013158:	e8 b3 23 00 00       	call   ffffffffc0015510 <_ZN4core5slice5index26slice_start_index_len_fail17hfbe4f54d0d3768aaE>
ffffffffc001315d:	0f 0b                	ud2    
ffffffffc001315f:	cc                   	int3   

ffffffffc0013160 <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i64$GT$3fmt17he365d173729e9b58E>:
ffffffffc0013160:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc0013167:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc001316a:	4c 8d 84 24 88 00 00 	lea    r8,[rsp+0x88]
ffffffffc0013171:	00 
ffffffffc0013172:	45 31 c9             	xor    r9d,r9d
ffffffffc0013175:	41 ba 30 00 00 00    	mov    r10d,0x30
ffffffffc001317b:	48 89 c2             	mov    rdx,rax
ffffffffc001317e:	66 90                	xchg   ax,ax
ffffffffc0013180:	89 c1                	mov    ecx,eax
ffffffffc0013182:	bf 57 00 00 00       	mov    edi,0x57
ffffffffc0013187:	80 e1 0f             	and    cl,0xf
ffffffffc001318a:	80 f9 0a             	cmp    cl,0xa
ffffffffc001318d:	41 0f 42 fa          	cmovb  edi,r10d
ffffffffc0013191:	48 c1 ea 04          	shr    rdx,0x4
ffffffffc0013195:	49 ff c1             	inc    r9
ffffffffc0013198:	40 00 cf             	add    dil,cl
ffffffffc001319b:	41 88 78 ff          	mov    BYTE PTR [r8-0x1],dil
ffffffffc001319f:	49 ff c8             	dec    r8
ffffffffc00131a2:	48 83 f8 0f          	cmp    rax,0xf
ffffffffc00131a6:	48 89 d0             	mov    rax,rdx
ffffffffc00131a9:	77 d5                	ja     ffffffffc0013180 <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i64$GT$3fmt17he365d173729e9b58E+0x20>
ffffffffc00131ab:	bf 80 00 00 00       	mov    edi,0x80
ffffffffc00131b0:	4c 29 cf             	sub    rdi,r9
ffffffffc00131b3:	48 81 ff 81 00 00 00 	cmp    rdi,0x81
ffffffffc00131ba:	73 21                	jae    ffffffffc00131dd <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i64$GT$3fmt17he365d173729e9b58E+0x7d>
ffffffffc00131bc:	48 89 f7             	mov    rdi,rsi
ffffffffc00131bf:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc00131c4:	be 01 00 00 00       	mov    esi,0x1
ffffffffc00131c9:	48 c7 c2 00 74 01 c0 	mov    rdx,0xffffffffc0017400
ffffffffc00131d0:	e8 bb 03 00 00       	call   ffffffffc0013590 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E>
ffffffffc00131d5:	48 81 c4 88 00 00 00 	add    rsp,0x88
ffffffffc00131dc:	c3                   	ret    
ffffffffc00131dd:	be 80 00 00 00       	mov    esi,0x80
ffffffffc00131e2:	48 c7 c2 e8 73 01 c0 	mov    rdx,0xffffffffc00173e8
ffffffffc00131e9:	e8 22 23 00 00       	call   ffffffffc0015510 <_ZN4core5slice5index26slice_start_index_len_fail17hfbe4f54d0d3768aaE>
ffffffffc00131ee:	0f 0b                	ud2    

ffffffffc00131f0 <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i64$GT$3fmt17h85d8853bf1cde852E>:
ffffffffc00131f0:	48 81 ec 88 00 00 00 	sub    rsp,0x88
ffffffffc00131f7:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc00131fa:	4c 8d 84 24 88 00 00 	lea    r8,[rsp+0x88]
ffffffffc0013201:	00 
ffffffffc0013202:	45 31 c9             	xor    r9d,r9d
ffffffffc0013205:	41 ba 30 00 00 00    	mov    r10d,0x30
ffffffffc001320b:	48 89 c2             	mov    rdx,rax
ffffffffc001320e:	66 90                	xchg   ax,ax
ffffffffc0013210:	89 c1                	mov    ecx,eax
ffffffffc0013212:	bf 37 00 00 00       	mov    edi,0x37
ffffffffc0013217:	80 e1 0f             	and    cl,0xf
ffffffffc001321a:	80 f9 0a             	cmp    cl,0xa
ffffffffc001321d:	41 0f 42 fa          	cmovb  edi,r10d
ffffffffc0013221:	48 c1 ea 04          	shr    rdx,0x4
ffffffffc0013225:	49 ff c1             	inc    r9
ffffffffc0013228:	40 00 cf             	add    dil,cl
ffffffffc001322b:	41 88 78 ff          	mov    BYTE PTR [r8-0x1],dil
ffffffffc001322f:	49 ff c8             	dec    r8
ffffffffc0013232:	48 83 f8 0f          	cmp    rax,0xf
ffffffffc0013236:	48 89 d0             	mov    rax,rdx
ffffffffc0013239:	77 d5                	ja     ffffffffc0013210 <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i64$GT$3fmt17h85d8853bf1cde852E+0x20>
ffffffffc001323b:	bf 80 00 00 00       	mov    edi,0x80
ffffffffc0013240:	4c 29 cf             	sub    rdi,r9
ffffffffc0013243:	48 81 ff 81 00 00 00 	cmp    rdi,0x81
ffffffffc001324a:	73 21                	jae    ffffffffc001326d <_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i64$GT$3fmt17h85d8853bf1cde852E+0x7d>
ffffffffc001324c:	48 89 f7             	mov    rdi,rsi
ffffffffc001324f:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc0013254:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0013259:	48 c7 c2 00 74 01 c0 	mov    rdx,0xffffffffc0017400
ffffffffc0013260:	e8 2b 03 00 00       	call   ffffffffc0013590 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E>
ffffffffc0013265:	48 81 c4 88 00 00 00 	add    rsp,0x88
ffffffffc001326c:	c3                   	ret    
ffffffffc001326d:	be 80 00 00 00       	mov    esi,0x80
ffffffffc0013272:	48 c7 c2 e8 73 01 c0 	mov    rdx,0xffffffffc00173e8
ffffffffc0013279:	e8 92 22 00 00       	call   ffffffffc0015510 <_ZN4core5slice5index26slice_start_index_len_fail17hfbe4f54d0d3768aaE>
ffffffffc001327e:	0f 0b                	ud2    

ffffffffc0013280 <_ZN4core3ops8function6FnOnce9call_once17hf9c1c93a2dfcdf92E.llvm.175273845903478457>:
ffffffffc0013280:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0013283:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001328a:	84 00 00 00 00 00 
ffffffffc0013290:	eb fe                	jmp    ffffffffc0013290 <_ZN4core3ops8function6FnOnce9call_once17hf9c1c93a2dfcdf92E.llvm.175273845903478457+0x10>
ffffffffc0013292:	cc                   	int3   
ffffffffc0013293:	cc                   	int3   
ffffffffc0013294:	cc                   	int3   
ffffffffc0013295:	cc                   	int3   
ffffffffc0013296:	cc                   	int3   
ffffffffc0013297:	cc                   	int3   
ffffffffc0013298:	cc                   	int3   
ffffffffc0013299:	cc                   	int3   
ffffffffc001329a:	cc                   	int3   
ffffffffc001329b:	cc                   	int3   
ffffffffc001329c:	cc                   	int3   
ffffffffc001329d:	cc                   	int3   
ffffffffc001329e:	cc                   	int3   
ffffffffc001329f:	cc                   	int3   

ffffffffc00132a0 <_ZN59_$LT$core..fmt..Arguments$u20$as$u20$core..fmt..Display$GT$3fmt17hfe84a583f0c1a666E>:
ffffffffc00132a0:	48 83 ec 38          	sub    rsp,0x38
ffffffffc00132a4:	48 8b 57 20          	mov    rdx,QWORD PTR [rdi+0x20]
ffffffffc00132a8:	4c 8b 47 18          	mov    r8,QWORD PTR [rdi+0x18]
ffffffffc00132ac:	48 8b 46 20          	mov    rax,QWORD PTR [rsi+0x20]
ffffffffc00132b0:	48 8b 4f 28          	mov    rcx,QWORD PTR [rdi+0x28]
ffffffffc00132b4:	48 8b 76 28          	mov    rsi,QWORD PTR [rsi+0x28]
ffffffffc00132b8:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
ffffffffc00132bd:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
ffffffffc00132c1:	4c 89 44 24 20       	mov    QWORD PTR [rsp+0x20],r8
ffffffffc00132c6:	4c 8b 07             	mov    r8,QWORD PTR [rdi]
ffffffffc00132c9:	48 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],rcx
ffffffffc00132ce:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
ffffffffc00132d3:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
ffffffffc00132d7:	48 89 c7             	mov    rdi,rax
ffffffffc00132da:	4c 89 44 24 08       	mov    QWORD PTR [rsp+0x8],r8
ffffffffc00132df:	48 89 54 24 10       	mov    QWORD PTR [rsp+0x10],rdx
ffffffffc00132e4:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc00132e9:	e8 12 00 00 00       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc00132ee:	48 83 c4 38          	add    rsp,0x38
ffffffffc00132f2:	c3                   	ret    
ffffffffc00132f3:	cc                   	int3   
ffffffffc00132f4:	cc                   	int3   
ffffffffc00132f5:	cc                   	int3   
ffffffffc00132f6:	cc                   	int3   
ffffffffc00132f7:	cc                   	int3   
ffffffffc00132f8:	cc                   	int3   
ffffffffc00132f9:	cc                   	int3   
ffffffffc00132fa:	cc                   	int3   
ffffffffc00132fb:	cc                   	int3   
ffffffffc00132fc:	cc                   	int3   
ffffffffc00132fd:	cc                   	int3   
ffffffffc00132fe:	cc                   	int3   
ffffffffc00132ff:	cc                   	int3   

ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>:
ffffffffc0013300:	55                   	push   rbp
ffffffffc0013301:	41 57                	push   r15
ffffffffc0013303:	41 56                	push   r14
ffffffffc0013305:	41 55                	push   r13
ffffffffc0013307:	41 54                	push   r12
ffffffffc0013309:	53                   	push   rbx
ffffffffc001330a:	48 83 ec 48          	sub    rsp,0x48
ffffffffc001330e:	48 8b 5a 10          	mov    rbx,QWORD PTR [rdx+0x10]
ffffffffc0013312:	48 b8 00 00 00 00 20 	movabs rax,0x2000000000
ffffffffc0013319:	00 00 00 
ffffffffc001331c:	49 89 d7             	mov    r15,rdx
ffffffffc001331f:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
ffffffffc0013324:	c6 44 24 38 03       	mov    BYTE PTR [rsp+0x38],0x3
ffffffffc0013329:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
ffffffffc0013330:	00 
ffffffffc0013331:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
ffffffffc0013338:	00 00 
ffffffffc001333a:	48 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],rdi
ffffffffc001333f:	48 89 74 24 28       	mov    QWORD PTR [rsp+0x28],rsi
ffffffffc0013344:	48 85 db             	test   rbx,rbx
ffffffffc0013347:	0f 84 4a 01 00 00    	je     ffffffffc0013497 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x197>
ffffffffc001334d:	4d 6b 6f 18 38       	imul   r13,QWORD PTR [r15+0x18],0x38
ffffffffc0013352:	4d 85 ed             	test   r13,r13
ffffffffc0013355:	0f 84 ae 01 00 00    	je     ffffffffc0013509 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x209>
ffffffffc001335b:	49 8b 2f             	mov    rbp,QWORD PTR [r15]
ffffffffc001335e:	4d 8b 77 08          	mov    r14,QWORD PTR [r15+0x8]
ffffffffc0013362:	48 83 c3 20          	add    rbx,0x20
ffffffffc0013366:	45 31 e4             	xor    r12d,r12d
ffffffffc0013369:	48 83 c5 08          	add    rbp,0x8
ffffffffc001336d:	0f 1f 00             	nop    DWORD PTR [rax]
ffffffffc0013370:	4d 39 f4             	cmp    r12,r14
ffffffffc0013373:	0f 83 d8 01 00 00    	jae    ffffffffc0013551 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x251>
ffffffffc0013379:	48 8b 55 00          	mov    rdx,QWORD PTR [rbp+0x0]
ffffffffc001337d:	48 85 d2             	test   rdx,rdx
ffffffffc0013380:	74 19                	je     ffffffffc001339b <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x9b>
ffffffffc0013382:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
ffffffffc0013387:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
ffffffffc001338c:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
ffffffffc0013390:	ff 50 18             	call   QWORD PTR [rax+0x18]
ffffffffc0013393:	84 c0                	test   al,al
ffffffffc0013395:	0f 85 98 01 00 00    	jne    ffffffffc0013533 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x233>
ffffffffc001339b:	8b 53 08             	mov    edx,DWORD PTR [rbx+0x8]
ffffffffc001339e:	49 8b 47 20          	mov    rax,QWORD PTR [r15+0x20]
ffffffffc00133a2:	49 8b 4f 28          	mov    rcx,QWORD PTR [r15+0x28]
ffffffffc00133a6:	89 54 24 34          	mov    DWORD PTR [rsp+0x34],edx
ffffffffc00133aa:	0f b6 53 10          	movzx  edx,BYTE PTR [rbx+0x10]
ffffffffc00133ae:	88 54 24 38          	mov    BYTE PTR [rsp+0x38],dl
ffffffffc00133b2:	8b 53 0c             	mov    edx,DWORD PTR [rbx+0xc]
ffffffffc00133b5:	89 54 24 30          	mov    DWORD PTR [rsp+0x30],edx
ffffffffc00133b9:	48 8b 53 f8          	mov    rdx,QWORD PTR [rbx-0x8]
ffffffffc00133bd:	48 85 d2             	test   rdx,rdx
ffffffffc00133c0:	74 2e                	je     ffffffffc00133f0 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0xf0>
ffffffffc00133c2:	83 fa 01             	cmp    edx,0x1
ffffffffc00133c5:	75 1e                	jne    ffffffffc00133e5 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0xe5>
ffffffffc00133c7:	48 8b 13             	mov    rdx,QWORD PTR [rbx]
ffffffffc00133ca:	48 39 ca             	cmp    rdx,rcx
ffffffffc00133cd:	0f 83 9c 01 00 00    	jae    ffffffffc001356f <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x26f>
ffffffffc00133d3:	48 c1 e2 04          	shl    rdx,0x4
ffffffffc00133d7:	48 c7 c6 80 32 01 c0 	mov    rsi,0xffffffffc0013280
ffffffffc00133de:	48 39 74 10 08       	cmp    QWORD PTR [rax+rdx*1+0x8],rsi
ffffffffc00133e3:	74 10                	je     ffffffffc00133f5 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0xf5>
ffffffffc00133e5:	31 f6                	xor    esi,esi
ffffffffc00133e7:	eb 18                	jmp    ffffffffc0013401 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x101>
ffffffffc00133e9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc00133f0:	48 89 da             	mov    rdx,rbx
ffffffffc00133f3:	eb 04                	jmp    ffffffffc00133f9 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0xf9>
ffffffffc00133f5:	48 8b 14 10          	mov    rdx,QWORD PTR [rax+rdx*1]
ffffffffc00133f9:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
ffffffffc00133fc:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0013401:	48 89 34 24          	mov    QWORD PTR [rsp],rsi
ffffffffc0013405:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
ffffffffc001340a:	48 8b 53 e8          	mov    rdx,QWORD PTR [rbx-0x18]
ffffffffc001340e:	48 85 d2             	test   rdx,rdx
ffffffffc0013411:	74 2d                	je     ffffffffc0013440 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x140>
ffffffffc0013413:	83 fa 01             	cmp    edx,0x1
ffffffffc0013416:	75 1f                	jne    ffffffffc0013437 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x137>
ffffffffc0013418:	48 8b 53 f0          	mov    rdx,QWORD PTR [rbx-0x10]
ffffffffc001341c:	48 39 ca             	cmp    rdx,rcx
ffffffffc001341f:	0f 83 4a 01 00 00    	jae    ffffffffc001356f <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x26f>
ffffffffc0013425:	48 c1 e2 04          	shl    rdx,0x4
ffffffffc0013429:	48 c7 c6 80 32 01 c0 	mov    rsi,0xffffffffc0013280
ffffffffc0013430:	48 39 74 10 08       	cmp    QWORD PTR [rax+rdx*1+0x8],rsi
ffffffffc0013435:	74 0f                	je     ffffffffc0013446 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x146>
ffffffffc0013437:	31 f6                	xor    esi,esi
ffffffffc0013439:	eb 17                	jmp    ffffffffc0013452 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x152>
ffffffffc001343b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0013440:	48 8d 53 f0          	lea    rdx,[rbx-0x10]
ffffffffc0013444:	eb 04                	jmp    ffffffffc001344a <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x14a>
ffffffffc0013446:	48 8b 14 10          	mov    rdx,QWORD PTR [rax+rdx*1]
ffffffffc001344a:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
ffffffffc001344d:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0013452:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc0013457:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
ffffffffc001345c:	48 8b 53 e0          	mov    rdx,QWORD PTR [rbx-0x20]
ffffffffc0013460:	48 39 ca             	cmp    rdx,rcx
ffffffffc0013463:	0f 83 ec 00 00 00    	jae    ffffffffc0013555 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x255>
ffffffffc0013469:	48 c1 e2 04          	shl    rdx,0x4
ffffffffc001346d:	48 89 e6             	mov    rsi,rsp
ffffffffc0013470:	48 8b 3c 10          	mov    rdi,QWORD PTR [rax+rdx*1]
ffffffffc0013474:	ff 54 10 08          	call   QWORD PTR [rax+rdx*1+0x8]
ffffffffc0013478:	84 c0                	test   al,al
ffffffffc001347a:	0f 85 b3 00 00 00    	jne    ffffffffc0013533 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x233>
ffffffffc0013480:	48 83 c5 10          	add    rbp,0x10
ffffffffc0013484:	48 83 c3 38          	add    rbx,0x38
ffffffffc0013488:	49 ff c4             	inc    r12
ffffffffc001348b:	49 83 c5 c8          	add    r13,0xffffffffffffffc8
ffffffffc001348f:	0f 85 db fe ff ff    	jne    ffffffffc0013370 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x70>
ffffffffc0013495:	eb 75                	jmp    ffffffffc001350c <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x20c>
ffffffffc0013497:	4d 8b 6f 28          	mov    r13,QWORD PTR [r15+0x28]
ffffffffc001349b:	4d 85 ed             	test   r13,r13
ffffffffc001349e:	0f 84 93 00 00 00    	je     ffffffffc0013537 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x237>
ffffffffc00134a4:	49 8b 47 08          	mov    rax,QWORD PTR [r15+0x8]
ffffffffc00134a8:	49 8b 6f 20          	mov    rbp,QWORD PTR [r15+0x20]
ffffffffc00134ac:	49 8b 1f             	mov    rbx,QWORD PTR [r15]
ffffffffc00134af:	49 c1 e5 04          	shl    r13,0x4
ffffffffc00134b3:	45 31 f6             	xor    r14d,r14d
ffffffffc00134b6:	45 31 e4             	xor    r12d,r12d
ffffffffc00134b9:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
ffffffffc00134be:	66 90                	xchg   ax,ax
ffffffffc00134c0:	4c 3b 64 24 40       	cmp    r12,QWORD PTR [rsp+0x40]
ffffffffc00134c5:	0f 83 86 00 00 00    	jae    ffffffffc0013551 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x251>
ffffffffc00134cb:	4a 8b 54 33 08       	mov    rdx,QWORD PTR [rbx+r14*1+0x8]
ffffffffc00134d0:	48 85 d2             	test   rdx,rdx
ffffffffc00134d3:	74 15                	je     ffffffffc00134ea <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x1ea>
ffffffffc00134d5:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
ffffffffc00134da:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
ffffffffc00134df:	4a 8b 34 33          	mov    rsi,QWORD PTR [rbx+r14*1]
ffffffffc00134e3:	ff 50 18             	call   QWORD PTR [rax+0x18]
ffffffffc00134e6:	84 c0                	test   al,al
ffffffffc00134e8:	75 49                	jne    ffffffffc0013533 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x233>
ffffffffc00134ea:	4a 8b 7c 35 00       	mov    rdi,QWORD PTR [rbp+r14*1+0x0]
ffffffffc00134ef:	48 89 e6             	mov    rsi,rsp
ffffffffc00134f2:	42 ff 54 35 08       	call   QWORD PTR [rbp+r14*1+0x8]
ffffffffc00134f7:	84 c0                	test   al,al
ffffffffc00134f9:	75 38                	jne    ffffffffc0013533 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x233>
ffffffffc00134fb:	49 83 c6 10          	add    r14,0x10
ffffffffc00134ff:	49 ff c4             	inc    r12
ffffffffc0013502:	4d 39 f5             	cmp    r13,r14
ffffffffc0013505:	75 b9                	jne    ffffffffc00134c0 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x1c0>
ffffffffc0013507:	eb 03                	jmp    ffffffffc001350c <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x20c>
ffffffffc0013509:	45 31 e4             	xor    r12d,r12d
ffffffffc001350c:	4d 3b 67 08          	cmp    r12,QWORD PTR [r15+0x8]
ffffffffc0013510:	73 2e                	jae    ffffffffc0013540 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x240>
ffffffffc0013512:	49 8b 07             	mov    rax,QWORD PTR [r15]
ffffffffc0013515:	49 c1 e4 04          	shl    r12,0x4
ffffffffc0013519:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
ffffffffc001351e:	48 8b 4c 24 28       	mov    rcx,QWORD PTR [rsp+0x28]
ffffffffc0013523:	4a 8b 34 20          	mov    rsi,QWORD PTR [rax+r12*1]
ffffffffc0013527:	4a 8b 54 20 08       	mov    rdx,QWORD PTR [rax+r12*1+0x8]
ffffffffc001352c:	ff 51 18             	call   QWORD PTR [rcx+0x18]
ffffffffc001352f:	84 c0                	test   al,al
ffffffffc0013531:	74 0d                	je     ffffffffc0013540 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x240>
ffffffffc0013533:	b0 01                	mov    al,0x1
ffffffffc0013535:	eb 0b                	jmp    ffffffffc0013542 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x242>
ffffffffc0013537:	45 31 e4             	xor    r12d,r12d
ffffffffc001353a:	4d 3b 67 08          	cmp    r12,QWORD PTR [r15+0x8]
ffffffffc001353e:	72 d2                	jb     ffffffffc0013512 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE+0x212>
ffffffffc0013540:	31 c0                	xor    eax,eax
ffffffffc0013542:	48 83 c4 48          	add    rsp,0x48
ffffffffc0013546:	5b                   	pop    rbx
ffffffffc0013547:	41 5c                	pop    r12
ffffffffc0013549:	41 5d                	pop    r13
ffffffffc001354b:	41 5e                	pop    r14
ffffffffc001354d:	41 5f                	pop    r15
ffffffffc001354f:	5d                   	pop    rbp
ffffffffc0013550:	c3                   	ret    
ffffffffc0013551:	0f 0b                	ud2    
ffffffffc0013553:	0f 0b                	ud2    
ffffffffc0013555:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc001355a:	48 c7 c7 47 79 01 c0 	mov    rdi,0xffffffffc0017947
ffffffffc0013561:	48 c7 c2 78 79 01 c0 	mov    rdx,0xffffffffc0017978
ffffffffc0013568:	e8 c3 10 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001356d:	0f 0b                	ud2    
ffffffffc001356f:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0013574:	48 c7 c7 90 6c 01 c0 	mov    rdi,0xffffffffc0016c90
ffffffffc001357b:	48 c7 c2 90 79 01 c0 	mov    rdx,0xffffffffc0017990
ffffffffc0013582:	e8 a9 10 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0013587:	0f 0b                	ud2    
ffffffffc0013589:	cc                   	int3   
ffffffffc001358a:	cc                   	int3   
ffffffffc001358b:	cc                   	int3   
ffffffffc001358c:	cc                   	int3   
ffffffffc001358d:	cc                   	int3   
ffffffffc001358e:	cc                   	int3   
ffffffffc001358f:	cc                   	int3   

ffffffffc0013590 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E>:
ffffffffc0013590:	55                   	push   rbp
ffffffffc0013591:	41 57                	push   r15
ffffffffc0013593:	41 56                	push   r14
ffffffffc0013595:	41 55                	push   r13
ffffffffc0013597:	41 54                	push   r12
ffffffffc0013599:	53                   	push   rbx
ffffffffc001359a:	48 83 ec 28          	sub    rsp,0x28
ffffffffc001359e:	4d 89 ce             	mov    r14,r9
ffffffffc00135a1:	4d 89 c7             	mov    r15,r8
ffffffffc00135a4:	48 89 cb             	mov    rbx,rcx
ffffffffc00135a7:	49 89 d5             	mov    r13,rdx
ffffffffc00135aa:	49 89 fc             	mov    r12,rdi
ffffffffc00135ad:	85 f6                	test   esi,esi
ffffffffc00135af:	74 5d                	je     ffffffffc001360e <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x7e>
ffffffffc00135b1:	41 8b 44 24 30       	mov    eax,DWORD PTR [r12+0x30]
ffffffffc00135b6:	a8 01                	test   al,0x1
ffffffffc00135b8:	75 75                	jne    ffffffffc001362f <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x9f>
ffffffffc00135ba:	c7 04 24 00 00 11 00 	mov    DWORD PTR [rsp],0x110000
ffffffffc00135c1:	4c 89 f5             	mov    rbp,r14
ffffffffc00135c4:	a8 04                	test   al,0x4
ffffffffc00135c6:	74 62                	je     ffffffffc001362a <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x9a>
ffffffffc00135c8:	48 85 db             	test   rbx,rbx
ffffffffc00135cb:	0f 88 35 04 00 00    	js     ffffffffc0013a06 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x476>
ffffffffc00135d1:	48 83 fb 20          	cmp    rbx,0x20
ffffffffc00135d5:	73 71                	jae    ffffffffc0013648 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0xb8>
ffffffffc00135d7:	48 85 db             	test   rbx,rbx
ffffffffc00135da:	0f 84 aa 01 00 00    	je     ffffffffc001378a <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x1fa>
ffffffffc00135e0:	31 c9                	xor    ecx,ecx
ffffffffc00135e2:	31 c0                	xor    eax,eax
ffffffffc00135e4:	66 66 66 2e 0f 1f 84 	data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc00135eb:	00 00 00 00 00 
ffffffffc00135f0:	31 d2                	xor    edx,edx
ffffffffc00135f2:	41 80 7c 0d 00 c0    	cmp    BYTE PTR [r13+rcx*1+0x0],0xc0
ffffffffc00135f8:	0f 9d c2             	setge  dl
ffffffffc00135fb:	48 01 d0             	add    rax,rdx
ffffffffc00135fe:	0f 82 66 03 00 00    	jb     ffffffffc001396a <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x3da>
ffffffffc0013604:	48 ff c1             	inc    rcx
ffffffffc0013607:	48 39 cb             	cmp    rbx,rcx
ffffffffc001360a:	75 e4                	jne    ffffffffc00135f0 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x60>
ffffffffc001360c:	eb 45                	jmp    ffffffffc0013653 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0xc3>
ffffffffc001360e:	4c 89 f5             	mov    rbp,r14
ffffffffc0013611:	48 ff c5             	inc    rbp
ffffffffc0013614:	0f 84 6a 03 00 00    	je     ffffffffc0013984 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x3f4>
ffffffffc001361a:	41 8b 44 24 30       	mov    eax,DWORD PTR [r12+0x30]
ffffffffc001361f:	c7 04 24 2d 00 00 00 	mov    DWORD PTR [rsp],0x2d
ffffffffc0013626:	a8 04                	test   al,0x4
ffffffffc0013628:	75 9e                	jne    ffffffffc00135c8 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x38>
ffffffffc001362a:	45 31 ed             	xor    r13d,r13d
ffffffffc001362d:	eb 2d                	jmp    ffffffffc001365c <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0xcc>
ffffffffc001362f:	4c 89 f5             	mov    rbp,r14
ffffffffc0013632:	48 ff c5             	inc    rbp
ffffffffc0013635:	0f 84 63 03 00 00    	je     ffffffffc001399e <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x40e>
ffffffffc001363b:	c7 04 24 2b 00 00 00 	mov    DWORD PTR [rsp],0x2b
ffffffffc0013642:	a8 04                	test   al,0x4
ffffffffc0013644:	74 e4                	je     ffffffffc001362a <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x9a>
ffffffffc0013646:	eb 80                	jmp    ffffffffc00135c8 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x38>
ffffffffc0013648:	4c 89 ef             	mov    rdi,r13
ffffffffc001364b:	48 89 de             	mov    rsi,rbx
ffffffffc001364e:	e8 5d 14 00 00       	call   ffffffffc0014ab0 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E>
ffffffffc0013653:	48 01 c5             	add    rbp,rax
ffffffffc0013656:	0f 82 39 01 00 00    	jb     ffffffffc0013795 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x205>
ffffffffc001365c:	49 83 3c 24 00       	cmp    QWORD PTR [r12],0x0
ffffffffc0013661:	74 50                	je     ffffffffc00136b3 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x123>
ffffffffc0013663:	4c 89 7c 24 18       	mov    QWORD PTR [rsp+0x18],r15
ffffffffc0013668:	4d 8b 7c 24 08       	mov    r15,QWORD PTR [r12+0x8]
ffffffffc001366d:	4c 39 fd             	cmp    rbp,r15
ffffffffc0013670:	73 6b                	jae    ffffffffc00136dd <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x14d>
ffffffffc0013672:	41 f6 44 24 30 08    	test   BYTE PTR [r12+0x30],0x8
ffffffffc0013678:	0f 85 a0 00 00 00    	jne    ffffffffc001371e <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x18e>
ffffffffc001367e:	49 29 ef             	sub    r15,rbp
ffffffffc0013681:	0f 82 31 03 00 00    	jb     ffffffffc00139b8 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x428>
ffffffffc0013687:	41 8b 4c 24 38       	mov    ecx,DWORD PTR [r12+0x38]
ffffffffc001368c:	b8 01 00 00 00       	mov    eax,0x1
ffffffffc0013691:	4c 89 74 24 20       	mov    QWORD PTR [rsp+0x20],r14
ffffffffc0013696:	80 f9 03             	cmp    cl,0x3
ffffffffc0013699:	0f 45 c1             	cmovne eax,ecx
ffffffffc001369c:	84 c0                	test   al,al
ffffffffc001369e:	0f 84 0b 01 00 00    	je     ffffffffc00137af <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x21f>
ffffffffc00136a4:	3c 01                	cmp    al,0x1
ffffffffc00136a6:	0f 85 0d 01 00 00    	jne    ffffffffc00137b9 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x229>
ffffffffc00136ac:	31 c0                	xor    eax,eax
ffffffffc00136ae:	e9 18 01 00 00       	jmp    ffffffffc00137cb <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x23b>
ffffffffc00136b3:	8b 34 24             	mov    esi,DWORD PTR [rsp]
ffffffffc00136b6:	4c 89 e7             	mov    rdi,r12
ffffffffc00136b9:	4c 89 ea             	mov    rdx,r13
ffffffffc00136bc:	48 89 d9             	mov    rcx,rbx
ffffffffc00136bf:	e8 4c 03 00 00       	call   ffffffffc0013a10 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E>
ffffffffc00136c4:	b3 01                	mov    bl,0x1
ffffffffc00136c6:	84 c0                	test   al,al
ffffffffc00136c8:	0f 85 06 02 00 00    	jne    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc00136ce:	49 8b 44 24 28       	mov    rax,QWORD PTR [r12+0x28]
ffffffffc00136d3:	49 8b 7c 24 20       	mov    rdi,QWORD PTR [r12+0x20]
ffffffffc00136d8:	4c 89 fe             	mov    rsi,r15
ffffffffc00136db:	eb 2a                	jmp    ffffffffc0013707 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x177>
ffffffffc00136dd:	8b 34 24             	mov    esi,DWORD PTR [rsp]
ffffffffc00136e0:	4c 89 e7             	mov    rdi,r12
ffffffffc00136e3:	4c 89 ea             	mov    rdx,r13
ffffffffc00136e6:	48 89 d9             	mov    rcx,rbx
ffffffffc00136e9:	e8 22 03 00 00       	call   ffffffffc0013a10 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E>
ffffffffc00136ee:	48 8b 74 24 18       	mov    rsi,QWORD PTR [rsp+0x18]
ffffffffc00136f3:	b3 01                	mov    bl,0x1
ffffffffc00136f5:	84 c0                	test   al,al
ffffffffc00136f7:	0f 85 d7 01 00 00    	jne    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc00136fd:	49 8b 44 24 28       	mov    rax,QWORD PTR [r12+0x28]
ffffffffc0013702:	49 8b 7c 24 20       	mov    rdi,QWORD PTR [r12+0x20]
ffffffffc0013707:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
ffffffffc001370b:	4c 89 f2             	mov    rdx,r14
ffffffffc001370e:	48 83 c4 28          	add    rsp,0x28
ffffffffc0013712:	5b                   	pop    rbx
ffffffffc0013713:	41 5c                	pop    r12
ffffffffc0013715:	41 5d                	pop    r13
ffffffffc0013717:	41 5e                	pop    r14
ffffffffc0013719:	41 5f                	pop    r15
ffffffffc001371b:	5d                   	pop    rbp
ffffffffc001371c:	ff e0                	jmp    rax
ffffffffc001371e:	41 8b 44 24 34       	mov    eax,DWORD PTR [r12+0x34]
ffffffffc0013723:	41 c7 44 24 34 30 00 	mov    DWORD PTR [r12+0x34],0x30
ffffffffc001372a:	00 00 
ffffffffc001372c:	4c 89 e7             	mov    rdi,r12
ffffffffc001372f:	4c 89 ea             	mov    rdx,r13
ffffffffc0013732:	48 89 d9             	mov    rcx,rbx
ffffffffc0013735:	89 44 24 10          	mov    DWORD PTR [rsp+0x10],eax
ffffffffc0013739:	41 8a 44 24 38       	mov    al,BYTE PTR [r12+0x38]
ffffffffc001373e:	41 c6 44 24 38 01    	mov    BYTE PTR [r12+0x38],0x1
ffffffffc0013744:	88 44 24 08          	mov    BYTE PTR [rsp+0x8],al
ffffffffc0013748:	8b 34 24             	mov    esi,DWORD PTR [rsp]
ffffffffc001374b:	e8 c0 02 00 00       	call   ffffffffc0013a10 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E>
ffffffffc0013750:	b3 01                	mov    bl,0x1
ffffffffc0013752:	84 c0                	test   al,al
ffffffffc0013754:	0f 85 7a 01 00 00    	jne    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc001375a:	49 29 ef             	sub    r15,rbp
ffffffffc001375d:	0f 82 6f 02 00 00    	jb     ffffffffc00139d2 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x442>
ffffffffc0013763:	41 8b 4c 24 38       	mov    ecx,DWORD PTR [r12+0x38]
ffffffffc0013768:	b8 01 00 00 00       	mov    eax,0x1
ffffffffc001376d:	80 f9 03             	cmp    cl,0x3
ffffffffc0013770:	0f 45 c1             	cmovne eax,ecx
ffffffffc0013773:	84 c0                	test   al,al
ffffffffc0013775:	0f 84 14 01 00 00    	je     ffffffffc001388f <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x2ff>
ffffffffc001377b:	3c 01                	cmp    al,0x1
ffffffffc001377d:	0f 85 15 01 00 00    	jne    ffffffffc0013898 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x308>
ffffffffc0013783:	31 c0                	xor    eax,eax
ffffffffc0013785:	e9 20 01 00 00       	jmp    ffffffffc00138aa <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x31a>
ffffffffc001378a:	31 c0                	xor    eax,eax
ffffffffc001378c:	48 01 c5             	add    rbp,rax
ffffffffc001378f:	0f 83 c7 fe ff ff    	jae    ffffffffc001365c <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0xcc>
ffffffffc0013795:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001379a:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc00137a1:	48 c7 c2 d8 79 01 c0 	mov    rdx,0xffffffffc00179d8
ffffffffc00137a8:	e8 83 0e 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00137ad:	0f 0b                	ud2    
ffffffffc00137af:	4c 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],r15
ffffffffc00137b4:	45 31 ff             	xor    r15d,r15d
ffffffffc00137b7:	eb 17                	jmp    ffffffffc00137d0 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x240>
ffffffffc00137b9:	4c 89 f8             	mov    rax,r15
ffffffffc00137bc:	48 ff c0             	inc    rax
ffffffffc00137bf:	0f 84 27 02 00 00    	je     ffffffffc00139ec <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x45c>
ffffffffc00137c5:	49 d1 ef             	shr    r15,1
ffffffffc00137c8:	48 d1 e8             	shr    rax,1
ffffffffc00137cb:	48 89 44 24 08       	mov    QWORD PTR [rsp+0x8],rax
ffffffffc00137d0:	4c 89 e0             	mov    rax,r12
ffffffffc00137d3:	49 8b 6c 24 20       	mov    rbp,QWORD PTR [r12+0x20]
ffffffffc00137d8:	4d 8b 64 24 28       	mov    r12,QWORD PTR [r12+0x28]
ffffffffc00137dd:	49 ff c7             	inc    r15
ffffffffc00137e0:	44 8b 70 34          	mov    r14d,DWORD PTR [rax+0x34]
ffffffffc00137e4:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
ffffffffc00137e9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc00137f0:	49 ff cf             	dec    r15
ffffffffc00137f3:	74 14                	je     ffffffffc0013809 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x279>
ffffffffc00137f5:	48 89 ef             	mov    rdi,rbp
ffffffffc00137f8:	44 89 f6             	mov    esi,r14d
ffffffffc00137fb:	41 ff 54 24 20       	call   QWORD PTR [r12+0x20]
ffffffffc0013800:	84 c0                	test   al,al
ffffffffc0013802:	74 ec                	je     ffffffffc00137f0 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x260>
ffffffffc0013804:	e9 c9 00 00 00       	jmp    ffffffffc00138d2 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x342>
ffffffffc0013809:	41 81 fe 00 00 11 00 	cmp    r14d,0x110000
ffffffffc0013810:	0f 84 bc 00 00 00    	je     ffffffffc00138d2 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x342>
ffffffffc0013816:	48 8b 6c 24 10       	mov    rbp,QWORD PTR [rsp+0x10]
ffffffffc001381b:	8b 34 24             	mov    esi,DWORD PTR [rsp]
ffffffffc001381e:	4c 89 ea             	mov    rdx,r13
ffffffffc0013821:	48 89 d9             	mov    rcx,rbx
ffffffffc0013824:	48 89 ef             	mov    rdi,rbp
ffffffffc0013827:	e8 e4 01 00 00       	call   ffffffffc0013a10 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E>
ffffffffc001382c:	84 c0                	test   al,al
ffffffffc001382e:	0f 85 9e 00 00 00    	jne    ffffffffc00138d2 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x342>
ffffffffc0013834:	48 8b 7d 20          	mov    rdi,QWORD PTR [rbp+0x20]
ffffffffc0013838:	48 8b 45 28          	mov    rax,QWORD PTR [rbp+0x28]
ffffffffc001383c:	48 8b 74 24 18       	mov    rsi,QWORD PTR [rsp+0x18]
ffffffffc0013841:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
ffffffffc0013846:	ff 50 18             	call   QWORD PTR [rax+0x18]
ffffffffc0013849:	b3 01                	mov    bl,0x1
ffffffffc001384b:	84 c0                	test   al,al
ffffffffc001384d:	0f 85 81 00 00 00    	jne    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc0013853:	48 8b 5c 24 08       	mov    rbx,QWORD PTR [rsp+0x8]
ffffffffc0013858:	4c 8b 7d 20          	mov    r15,QWORD PTR [rbp+0x20]
ffffffffc001385c:	4c 8b 65 28          	mov    r12,QWORD PTR [rbp+0x28]
ffffffffc0013860:	48 c7 c5 ff ff ff ff 	mov    rbp,0xffffffffffffffff
ffffffffc0013867:	48 f7 db             	neg    rbx
ffffffffc001386a:	48 8d 04 2b          	lea    rax,[rbx+rbp*1]
ffffffffc001386e:	48 83 f8 ff          	cmp    rax,0xffffffffffffffff
ffffffffc0013872:	0f 84 e0 00 00 00    	je     ffffffffc0013958 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x3c8>
ffffffffc0013878:	4c 89 ff             	mov    rdi,r15
ffffffffc001387b:	44 89 f6             	mov    esi,r14d
ffffffffc001387e:	41 ff 54 24 20       	call   QWORD PTR [r12+0x20]
ffffffffc0013883:	48 ff c5             	inc    rbp
ffffffffc0013886:	84 c0                	test   al,al
ffffffffc0013888:	74 e0                	je     ffffffffc001386a <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x2da>
ffffffffc001388a:	e9 ce 00 00 00       	jmp    ffffffffc001395d <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x3cd>
ffffffffc001388f:	4c 89 3c 24          	mov    QWORD PTR [rsp],r15
ffffffffc0013893:	45 31 ff             	xor    r15d,r15d
ffffffffc0013896:	eb 16                	jmp    ffffffffc00138ae <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x31e>
ffffffffc0013898:	4c 89 f8             	mov    rax,r15
ffffffffc001389b:	48 ff c0             	inc    rax
ffffffffc001389e:	0f 84 48 01 00 00    	je     ffffffffc00139ec <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x45c>
ffffffffc00138a4:	49 d1 ef             	shr    r15,1
ffffffffc00138a7:	48 d1 e8             	shr    rax,1
ffffffffc00138aa:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc00138ae:	49 8b 6c 24 20       	mov    rbp,QWORD PTR [r12+0x20]
ffffffffc00138b3:	49 8b 5c 24 28       	mov    rbx,QWORD PTR [r12+0x28]
ffffffffc00138b8:	45 8b 6c 24 34       	mov    r13d,DWORD PTR [r12+0x34]
ffffffffc00138bd:	49 ff c7             	inc    r15
ffffffffc00138c0:	49 ff cf             	dec    r15
ffffffffc00138c3:	74 20                	je     ffffffffc00138e5 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x355>
ffffffffc00138c5:	48 89 ef             	mov    rdi,rbp
ffffffffc00138c8:	44 89 ee             	mov    esi,r13d
ffffffffc00138cb:	ff 53 20             	call   QWORD PTR [rbx+0x20]
ffffffffc00138ce:	84 c0                	test   al,al
ffffffffc00138d0:	74 ee                	je     ffffffffc00138c0 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x330>
ffffffffc00138d2:	b3 01                	mov    bl,0x1
ffffffffc00138d4:	89 d8                	mov    eax,ebx
ffffffffc00138d6:	48 83 c4 28          	add    rsp,0x28
ffffffffc00138da:	5b                   	pop    rbx
ffffffffc00138db:	41 5c                	pop    r12
ffffffffc00138dd:	41 5d                	pop    r13
ffffffffc00138df:	41 5e                	pop    r14
ffffffffc00138e1:	41 5f                	pop    r15
ffffffffc00138e3:	5d                   	pop    rbp
ffffffffc00138e4:	c3                   	ret    
ffffffffc00138e5:	b3 01                	mov    bl,0x1
ffffffffc00138e7:	41 81 fd 00 00 11 00 	cmp    r13d,0x110000
ffffffffc00138ee:	74 e4                	je     ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc00138f0:	49 8b 7c 24 20       	mov    rdi,QWORD PTR [r12+0x20]
ffffffffc00138f5:	49 8b 44 24 28       	mov    rax,QWORD PTR [r12+0x28]
ffffffffc00138fa:	48 8b 74 24 18       	mov    rsi,QWORD PTR [rsp+0x18]
ffffffffc00138ff:	4c 89 f2             	mov    rdx,r14
ffffffffc0013902:	ff 50 18             	call   QWORD PTR [rax+0x18]
ffffffffc0013905:	84 c0                	test   al,al
ffffffffc0013907:	75 cb                	jne    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc0013909:	4d 8b 7c 24 20       	mov    r15,QWORD PTR [r12+0x20]
ffffffffc001390e:	4d 8b 74 24 28       	mov    r14,QWORD PTR [r12+0x28]
ffffffffc0013913:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0013918:	48 8b 04 24          	mov    rax,QWORD PTR [rsp]
ffffffffc001391c:	48 01 e8             	add    rax,rbp
ffffffffc001391f:	48 83 f8 01          	cmp    rax,0x1
ffffffffc0013923:	74 1a                	je     ffffffffc001393f <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x3af>
ffffffffc0013925:	4c 89 ff             	mov    rdi,r15
ffffffffc0013928:	44 89 ee             	mov    esi,r13d
ffffffffc001392b:	41 ff 56 20          	call   QWORD PTR [r14+0x20]
ffffffffc001392f:	48 ff cd             	dec    rbp
ffffffffc0013932:	84 c0                	test   al,al
ffffffffc0013934:	74 e2                	je     ffffffffc0013918 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x388>
ffffffffc0013936:	48 f7 dd             	neg    rbp
ffffffffc0013939:	48 3b 2c 24          	cmp    rbp,QWORD PTR [rsp]
ffffffffc001393d:	72 95                	jb     ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc001393f:	8b 44 24 10          	mov    eax,DWORD PTR [rsp+0x10]
ffffffffc0013943:	8a 4c 24 08          	mov    cl,BYTE PTR [rsp+0x8]
ffffffffc0013947:	31 db                	xor    ebx,ebx
ffffffffc0013949:	41 89 44 24 34       	mov    DWORD PTR [r12+0x34],eax
ffffffffc001394e:	41 88 4c 24 38       	mov    BYTE PTR [r12+0x38],cl
ffffffffc0013953:	e9 7c ff ff ff       	jmp    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc0013958:	48 8b 6c 24 08       	mov    rbp,QWORD PTR [rsp+0x8]
ffffffffc001395d:	48 3b 6c 24 08       	cmp    rbp,QWORD PTR [rsp+0x8]
ffffffffc0013962:	0f 92 c3             	setb   bl
ffffffffc0013965:	e9 6a ff ff ff       	jmp    ffffffffc00138d4 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E+0x344>
ffffffffc001396a:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc001396f:	48 c7 c7 c0 7c 01 c0 	mov    rdi,0xffffffffc0017cc0
ffffffffc0013976:	48 c7 c2 20 7e 01 c0 	mov    rdx,0xffffffffc0017e20
ffffffffc001397d:	e8 ae 0c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0013982:	0f 0b                	ud2    
ffffffffc0013984:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0013989:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc0013990:	48 c7 c2 a8 79 01 c0 	mov    rdx,0xffffffffc00179a8
ffffffffc0013997:	e8 94 0c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001399c:	0f 0b                	ud2    
ffffffffc001399e:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00139a3:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc00139aa:	48 c7 c2 c0 79 01 c0 	mov    rdx,0xffffffffc00179c0
ffffffffc00139b1:	e8 7a 0c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00139b6:	0f 0b                	ud2    
ffffffffc00139b8:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00139bd:	48 c7 c7 60 78 01 c0 	mov    rdi,0xffffffffc0017860
ffffffffc00139c4:	48 c7 c2 08 7a 01 c0 	mov    rdx,0xffffffffc0017a08
ffffffffc00139cb:	e8 60 0c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00139d0:	0f 0b                	ud2    
ffffffffc00139d2:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00139d7:	48 c7 c7 60 78 01 c0 	mov    rdi,0xffffffffc0017860
ffffffffc00139de:	48 c7 c2 f0 79 01 c0 	mov    rdx,0xffffffffc00179f0
ffffffffc00139e5:	e8 46 0c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00139ea:	0f 0b                	ud2    
ffffffffc00139ec:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00139f1:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc00139f8:	48 c7 c2 20 7a 01 c0 	mov    rdx,0xffffffffc0017a20
ffffffffc00139ff:	e8 2c 0c 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0013a04:	0f 0b                	ud2    
ffffffffc0013a06:	0f 0b                	ud2    
ffffffffc0013a08:	0f 0b                	ud2    
ffffffffc0013a0a:	cc                   	int3   
ffffffffc0013a0b:	cc                   	int3   
ffffffffc0013a0c:	cc                   	int3   
ffffffffc0013a0d:	cc                   	int3   
ffffffffc0013a0e:	cc                   	int3   
ffffffffc0013a0f:	cc                   	int3   

ffffffffc0013a10 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E>:
ffffffffc0013a10:	41 57                	push   r15
ffffffffc0013a12:	41 56                	push   r14
ffffffffc0013a14:	53                   	push   rbx
ffffffffc0013a15:	49 89 ce             	mov    r14,rcx
ffffffffc0013a18:	49 89 d7             	mov    r15,rdx
ffffffffc0013a1b:	48 89 fb             	mov    rbx,rdi
ffffffffc0013a1e:	81 fe 00 00 11 00    	cmp    esi,0x110000
ffffffffc0013a24:	74 13                	je     ffffffffc0013a39 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E+0x29>
ffffffffc0013a26:	48 8b 7b 20          	mov    rdi,QWORD PTR [rbx+0x20]
ffffffffc0013a2a:	48 8b 43 28          	mov    rax,QWORD PTR [rbx+0x28]
ffffffffc0013a2e:	ff 50 20             	call   QWORD PTR [rax+0x20]
ffffffffc0013a31:	89 c1                	mov    ecx,eax
ffffffffc0013a33:	b0 01                	mov    al,0x1
ffffffffc0013a35:	84 c9                	test   cl,cl
ffffffffc0013a37:	75 20                	jne    ffffffffc0013a59 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E+0x49>
ffffffffc0013a39:	4d 85 ff             	test   r15,r15
ffffffffc0013a3c:	74 19                	je     ffffffffc0013a57 <_ZN4core3fmt9Formatter12pad_integral12write_prefix17h8bdb4d4c19c6fbb0E+0x47>
ffffffffc0013a3e:	48 8b 43 28          	mov    rax,QWORD PTR [rbx+0x28]
ffffffffc0013a42:	48 8b 7b 20          	mov    rdi,QWORD PTR [rbx+0x20]
ffffffffc0013a46:	4c 89 fe             	mov    rsi,r15
ffffffffc0013a49:	4c 89 f2             	mov    rdx,r14
ffffffffc0013a4c:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
ffffffffc0013a50:	5b                   	pop    rbx
ffffffffc0013a51:	41 5e                	pop    r14
ffffffffc0013a53:	41 5f                	pop    r15
ffffffffc0013a55:	ff e0                	jmp    rax
ffffffffc0013a57:	31 c0                	xor    eax,eax
ffffffffc0013a59:	5b                   	pop    rbx
ffffffffc0013a5a:	41 5e                	pop    r14
ffffffffc0013a5c:	41 5f                	pop    r15
ffffffffc0013a5e:	c3                   	ret    
ffffffffc0013a5f:	cc                   	int3   

ffffffffc0013a60 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E>:
ffffffffc0013a60:	55                   	push   rbp
ffffffffc0013a61:	41 57                	push   r15
ffffffffc0013a63:	41 56                	push   r14
ffffffffc0013a65:	41 55                	push   r13
ffffffffc0013a67:	41 54                	push   r12
ffffffffc0013a69:	53                   	push   rbx
ffffffffc0013a6a:	48 83 ec 28          	sub    rsp,0x28
ffffffffc0013a6e:	4c 8b 37             	mov    r14,QWORD PTR [rdi]
ffffffffc0013a71:	48 8b 47 10          	mov    rax,QWORD PTR [rdi+0x10]
ffffffffc0013a75:	49 89 d7             	mov    r15,rdx
ffffffffc0013a78:	49 89 f5             	mov    r13,rsi
ffffffffc0013a7b:	49 89 fc             	mov    r12,rdi
ffffffffc0013a7e:	49 83 fe 01          	cmp    r14,0x1
ffffffffc0013a82:	74 0a                	je     ffffffffc0013a8e <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x2e>
ffffffffc0013a84:	48 83 f8 01          	cmp    rax,0x1
ffffffffc0013a88:	0f 85 04 01 00 00    	jne    ffffffffc0013b92 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x132>
ffffffffc0013a8e:	48 83 f8 01          	cmp    rax,0x1
ffffffffc0013a92:	0f 85 84 00 00 00    	jne    ffffffffc0013b1c <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xbc>
ffffffffc0013a98:	49 8b 6c 24 18       	mov    rbp,QWORD PTR [r12+0x18]
ffffffffc0013a9d:	4b 8d 44 3d 00       	lea    rax,[r13+r15*1+0x0]
ffffffffc0013aa2:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
ffffffffc0013aa9:	00 00 
ffffffffc0013aab:	4c 89 6c 24 18       	mov    QWORD PTR [rsp+0x18],r13
ffffffffc0013ab0:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
ffffffffc0013ab5:	48 85 ed             	test   rbp,rbp
ffffffffc0013ab8:	74 1b                	je     ffffffffc0013ad5 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x75>
ffffffffc0013aba:	48 8d 5c 24 10       	lea    rbx,[rsp+0x10]
ffffffffc0013abf:	90                   	nop
ffffffffc0013ac0:	48 89 df             	mov    rdi,rbx
ffffffffc0013ac3:	e8 18 09 00 00       	call   ffffffffc00143e0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E>
ffffffffc0013ac8:	81 fa 00 00 11 00    	cmp    edx,0x110000
ffffffffc0013ace:	74 4c                	je     ffffffffc0013b1c <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xbc>
ffffffffc0013ad0:	48 ff cd             	dec    rbp
ffffffffc0013ad3:	75 eb                	jne    ffffffffc0013ac0 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x60>
ffffffffc0013ad5:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
ffffffffc0013ada:	e8 01 09 00 00       	call   ffffffffc00143e0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E>
ffffffffc0013adf:	81 fa 00 00 11 00    	cmp    edx,0x110000
ffffffffc0013ae5:	74 35                	je     ffffffffc0013b1c <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xbc>
ffffffffc0013ae7:	48 85 c0             	test   rax,rax
ffffffffc0013aea:	74 12                	je     ffffffffc0013afe <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x9e>
ffffffffc0013aec:	4c 39 f8             	cmp    rax,r15
ffffffffc0013aef:	73 11                	jae    ffffffffc0013b02 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xa2>
ffffffffc0013af1:	41 80 7c 05 00 bf    	cmp    BYTE PTR [r13+rax*1+0x0],0xbf
ffffffffc0013af7:	7e 16                	jle    ffffffffc0013b0f <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xaf>
ffffffffc0013af9:	48 89 c1             	mov    rcx,rax
ffffffffc0013afc:	eb 09                	jmp    ffffffffc0013b07 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xa7>
ffffffffc0013afe:	31 c9                	xor    ecx,ecx
ffffffffc0013b00:	eb 05                	jmp    ffffffffc0013b07 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xa7>
ffffffffc0013b02:	4c 89 f9             	mov    rcx,r15
ffffffffc0013b05:	75 08                	jne    ffffffffc0013b0f <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xaf>
ffffffffc0013b07:	48 89 c8             	mov    rax,rcx
ffffffffc0013b0a:	4c 89 e9             	mov    rcx,r13
ffffffffc0013b0d:	eb 02                	jmp    ffffffffc0013b11 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xb1>
ffffffffc0013b0f:	31 c9                	xor    ecx,ecx
ffffffffc0013b11:	48 85 c9             	test   rcx,rcx
ffffffffc0013b14:	4c 0f 45 e9          	cmovne r13,rcx
ffffffffc0013b18:	4c 0f 45 f8          	cmovne r15,rax
ffffffffc0013b1c:	4d 85 f6             	test   r14,r14
ffffffffc0013b1f:	74 71                	je     ffffffffc0013b92 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x132>
ffffffffc0013b21:	4d 85 ff             	test   r15,r15
ffffffffc0013b24:	0f 88 84 01 00 00    	js     ffffffffc0013cae <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x24e>
ffffffffc0013b2a:	49 8b 5c 24 08       	mov    rbx,QWORD PTR [r12+0x8]
ffffffffc0013b2f:	49 83 ff 20          	cmp    r15,0x20
ffffffffc0013b33:	73 29                	jae    ffffffffc0013b5e <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xfe>
ffffffffc0013b35:	4d 85 ff             	test   r15,r15
ffffffffc0013b38:	74 51                	je     ffffffffc0013b8b <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x12b>
ffffffffc0013b3a:	31 c9                	xor    ecx,ecx
ffffffffc0013b3c:	31 c0                	xor    eax,eax
ffffffffc0013b3e:	66 90                	xchg   ax,ax
ffffffffc0013b40:	31 d2                	xor    edx,edx
ffffffffc0013b42:	41 80 7c 0d 00 c0    	cmp    BYTE PTR [r13+rcx*1+0x0],0xc0
ffffffffc0013b48:	0f 9d c2             	setge  dl
ffffffffc0013b4b:	48 01 d0             	add    rax,rdx
ffffffffc0013b4e:	0f 82 26 01 00 00    	jb     ffffffffc0013c7a <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x21a>
ffffffffc0013b54:	48 ff c1             	inc    rcx
ffffffffc0013b57:	49 39 cf             	cmp    r15,rcx
ffffffffc0013b5a:	75 e4                	jne    ffffffffc0013b40 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0xe0>
ffffffffc0013b5c:	eb 0b                	jmp    ffffffffc0013b69 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x109>
ffffffffc0013b5e:	4c 89 ef             	mov    rdi,r13
ffffffffc0013b61:	4c 89 fe             	mov    rsi,r15
ffffffffc0013b64:	e8 47 0f 00 00       	call   ffffffffc0014ab0 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E>
ffffffffc0013b69:	48 29 c3             	sub    rbx,rax
ffffffffc0013b6c:	76 24                	jbe    ffffffffc0013b92 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x132>
ffffffffc0013b6e:	41 8b 44 24 38       	mov    eax,DWORD PTR [r12+0x38]
ffffffffc0013b73:	31 c9                	xor    ecx,ecx
ffffffffc0013b75:	4c 89 6c 24 08       	mov    QWORD PTR [rsp+0x8],r13
ffffffffc0013b7a:	3c 03                	cmp    al,0x3
ffffffffc0013b7c:	0f 44 c1             	cmove  eax,ecx
ffffffffc0013b7f:	84 c0                	test   al,al
ffffffffc0013b81:	74 33                	je     ffffffffc0013bb6 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x156>
ffffffffc0013b83:	3c 01                	cmp    al,0x1
ffffffffc0013b85:	75 37                	jne    ffffffffc0013bbe <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x15e>
ffffffffc0013b87:	31 c0                	xor    eax,eax
ffffffffc0013b89:	eb 45                	jmp    ffffffffc0013bd0 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x170>
ffffffffc0013b8b:	31 c0                	xor    eax,eax
ffffffffc0013b8d:	48 29 c3             	sub    rbx,rax
ffffffffc0013b90:	77 dc                	ja     ffffffffc0013b6e <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x10e>
ffffffffc0013b92:	49 8b 44 24 28       	mov    rax,QWORD PTR [r12+0x28]
ffffffffc0013b97:	49 8b 7c 24 20       	mov    rdi,QWORD PTR [r12+0x20]
ffffffffc0013b9c:	4c 89 ee             	mov    rsi,r13
ffffffffc0013b9f:	4c 89 fa             	mov    rdx,r15
ffffffffc0013ba2:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
ffffffffc0013ba6:	48 83 c4 28          	add    rsp,0x28
ffffffffc0013baa:	5b                   	pop    rbx
ffffffffc0013bab:	41 5c                	pop    r12
ffffffffc0013bad:	41 5d                	pop    r13
ffffffffc0013baf:	41 5e                	pop    r14
ffffffffc0013bb1:	41 5f                	pop    r15
ffffffffc0013bb3:	5d                   	pop    rbp
ffffffffc0013bb4:	ff e0                	jmp    rax
ffffffffc0013bb6:	48 89 1c 24          	mov    QWORD PTR [rsp],rbx
ffffffffc0013bba:	31 db                	xor    ebx,ebx
ffffffffc0013bbc:	eb 16                	jmp    ffffffffc0013bd4 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x174>
ffffffffc0013bbe:	48 89 d8             	mov    rax,rbx
ffffffffc0013bc1:	48 ff c0             	inc    rax
ffffffffc0013bc4:	0f 84 ca 00 00 00    	je     ffffffffc0013c94 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x234>
ffffffffc0013bca:	48 d1 eb             	shr    rbx,1
ffffffffc0013bcd:	48 d1 e8             	shr    rax,1
ffffffffc0013bd0:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc0013bd4:	4d 8b 6c 24 20       	mov    r13,QWORD PTR [r12+0x20]
ffffffffc0013bd9:	4d 8b 74 24 28       	mov    r14,QWORD PTR [r12+0x28]
ffffffffc0013bde:	41 8b 6c 24 34       	mov    ebp,DWORD PTR [r12+0x34]
ffffffffc0013be3:	48 ff c3             	inc    rbx
ffffffffc0013be6:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0013bed:	00 00 00 
ffffffffc0013bf0:	48 ff cb             	dec    rbx
ffffffffc0013bf3:	74 12                	je     ffffffffc0013c07 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x1a7>
ffffffffc0013bf5:	4c 89 ef             	mov    rdi,r13
ffffffffc0013bf8:	89 ee                	mov    esi,ebp
ffffffffc0013bfa:	41 ff 56 20          	call   QWORD PTR [r14+0x20]
ffffffffc0013bfe:	84 c0                	test   al,al
ffffffffc0013c00:	74 ee                	je     ffffffffc0013bf0 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x190>
ffffffffc0013c02:	41 b4 01             	mov    r12b,0x1
ffffffffc0013c05:	eb 61                	jmp    ffffffffc0013c68 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x208>
ffffffffc0013c07:	41 b4 01             	mov    r12b,0x1
ffffffffc0013c0a:	81 fd 00 00 11 00    	cmp    ebp,0x110000
ffffffffc0013c10:	74 56                	je     ffffffffc0013c68 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x208>
ffffffffc0013c12:	48 8b 74 24 08       	mov    rsi,QWORD PTR [rsp+0x8]
ffffffffc0013c17:	4c 89 ef             	mov    rdi,r13
ffffffffc0013c1a:	4c 89 fa             	mov    rdx,r15
ffffffffc0013c1d:	41 ff 56 18          	call   QWORD PTR [r14+0x18]
ffffffffc0013c21:	84 c0                	test   al,al
ffffffffc0013c23:	75 43                	jne    ffffffffc0013c68 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x208>
ffffffffc0013c25:	4c 8b 3c 24          	mov    r15,QWORD PTR [rsp]
ffffffffc0013c29:	48 c7 c3 ff ff ff ff 	mov    rbx,0xffffffffffffffff
ffffffffc0013c30:	49 f7 df             	neg    r15
ffffffffc0013c33:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0013c3a:	84 00 00 00 00 00 
ffffffffc0013c40:	49 8d 04 1f          	lea    rax,[r15+rbx*1]
ffffffffc0013c44:	48 83 f8 ff          	cmp    rax,0xffffffffffffffff
ffffffffc0013c48:	74 12                	je     ffffffffc0013c5c <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x1fc>
ffffffffc0013c4a:	4c 89 ef             	mov    rdi,r13
ffffffffc0013c4d:	89 ee                	mov    esi,ebp
ffffffffc0013c4f:	41 ff 56 20          	call   QWORD PTR [r14+0x20]
ffffffffc0013c53:	48 ff c3             	inc    rbx
ffffffffc0013c56:	84 c0                	test   al,al
ffffffffc0013c58:	74 e6                	je     ffffffffc0013c40 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x1e0>
ffffffffc0013c5a:	eb 04                	jmp    ffffffffc0013c60 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E+0x200>
ffffffffc0013c5c:	48 8b 1c 24          	mov    rbx,QWORD PTR [rsp]
ffffffffc0013c60:	48 3b 1c 24          	cmp    rbx,QWORD PTR [rsp]
ffffffffc0013c64:	41 0f 92 c4          	setb   r12b
ffffffffc0013c68:	44 89 e0             	mov    eax,r12d
ffffffffc0013c6b:	48 83 c4 28          	add    rsp,0x28
ffffffffc0013c6f:	5b                   	pop    rbx
ffffffffc0013c70:	41 5c                	pop    r12
ffffffffc0013c72:	41 5d                	pop    r13
ffffffffc0013c74:	41 5e                	pop    r14
ffffffffc0013c76:	41 5f                	pop    r15
ffffffffc0013c78:	5d                   	pop    rbp
ffffffffc0013c79:	c3                   	ret    
ffffffffc0013c7a:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0013c7f:	48 c7 c7 c0 7c 01 c0 	mov    rdi,0xffffffffc0017cc0
ffffffffc0013c86:	48 c7 c2 20 7e 01 c0 	mov    rdx,0xffffffffc0017e20
ffffffffc0013c8d:	e8 9e 09 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0013c92:	0f 0b                	ud2    
ffffffffc0013c94:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0013c99:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc0013ca0:	48 c7 c2 20 7a 01 c0 	mov    rdx,0xffffffffc0017a20
ffffffffc0013ca7:	e8 84 09 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0013cac:	0f 0b                	ud2    
ffffffffc0013cae:	0f 0b                	ud2    
ffffffffc0013cb0:	0f 0b                	ud2    
ffffffffc0013cb2:	cc                   	int3   
ffffffffc0013cb3:	cc                   	int3   
ffffffffc0013cb4:	cc                   	int3   
ffffffffc0013cb5:	cc                   	int3   
ffffffffc0013cb6:	cc                   	int3   
ffffffffc0013cb7:	cc                   	int3   
ffffffffc0013cb8:	cc                   	int3   
ffffffffc0013cb9:	cc                   	int3   
ffffffffc0013cba:	cc                   	int3   
ffffffffc0013cbb:	cc                   	int3   
ffffffffc0013cbc:	cc                   	int3   
ffffffffc0013cbd:	cc                   	int3   
ffffffffc0013cbe:	cc                   	int3   
ffffffffc0013cbf:	cc                   	int3   

ffffffffc0013cc0 <_ZN4core3fmt9Formatter15debug_lower_hex17h6865ac6c69cda674E>:
ffffffffc0013cc0:	8a 47 30             	mov    al,BYTE PTR [rdi+0x30]
ffffffffc0013cc3:	24 10                	and    al,0x10
ffffffffc0013cc5:	c0 e8 04             	shr    al,0x4
ffffffffc0013cc8:	c3                   	ret    
ffffffffc0013cc9:	cc                   	int3   
ffffffffc0013cca:	cc                   	int3   
ffffffffc0013ccb:	cc                   	int3   
ffffffffc0013ccc:	cc                   	int3   
ffffffffc0013ccd:	cc                   	int3   
ffffffffc0013cce:	cc                   	int3   
ffffffffc0013ccf:	cc                   	int3   

ffffffffc0013cd0 <_ZN4core3fmt9Formatter15debug_upper_hex17h9fa440d285b51edeE>:
ffffffffc0013cd0:	8a 47 30             	mov    al,BYTE PTR [rdi+0x30]
ffffffffc0013cd3:	24 20                	and    al,0x20
ffffffffc0013cd5:	c0 e8 05             	shr    al,0x5
ffffffffc0013cd8:	c3                   	ret    
ffffffffc0013cd9:	cc                   	int3   
ffffffffc0013cda:	cc                   	int3   
ffffffffc0013cdb:	cc                   	int3   
ffffffffc0013cdc:	cc                   	int3   
ffffffffc0013cdd:	cc                   	int3   
ffffffffc0013cde:	cc                   	int3   
ffffffffc0013cdf:	cc                   	int3   

ffffffffc0013ce0 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E>:
ffffffffc0013ce0:	55                   	push   rbp
ffffffffc0013ce1:	41 57                	push   r15
ffffffffc0013ce3:	41 56                	push   r14
ffffffffc0013ce5:	41 55                	push   r13
ffffffffc0013ce7:	41 54                	push   r12
ffffffffc0013ce9:	53                   	push   rbx
ffffffffc0013cea:	48 83 ec 48          	sub    rsp,0x48
ffffffffc0013cee:	48 8b 42 28          	mov    rax,QWORD PTR [rdx+0x28]
ffffffffc0013cf2:	4c 8b 6a 20          	mov    r13,QWORD PTR [rdx+0x20]
ffffffffc0013cf6:	48 89 f3             	mov    rbx,rsi
ffffffffc0013cf9:	48 89 fd             	mov    rbp,rdi
ffffffffc0013cfc:	be 22 00 00 00       	mov    esi,0x22
ffffffffc0013d01:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
ffffffffc0013d06:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
ffffffffc0013d0a:	4c 89 ef             	mov    rdi,r13
ffffffffc0013d0d:	49 89 c4             	mov    r12,rax
ffffffffc0013d10:	ff d0                	call   rax
ffffffffc0013d12:	84 c0                	test   al,al
ffffffffc0013d14:	74 11                	je     ffffffffc0013d27 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x47>
ffffffffc0013d16:	b0 01                	mov    al,0x1
ffffffffc0013d18:	48 83 c4 48          	add    rsp,0x48
ffffffffc0013d1c:	5b                   	pop    rbx
ffffffffc0013d1d:	41 5c                	pop    r12
ffffffffc0013d1f:	41 5d                	pop    r13
ffffffffc0013d21:	41 5e                	pop    r14
ffffffffc0013d23:	41 5f                	pop    r15
ffffffffc0013d25:	5d                   	pop    rbp
ffffffffc0013d26:	c3                   	ret    
ffffffffc0013d27:	48 8d 44 1d 00       	lea    rax,[rbp+rbx*1+0x0]
ffffffffc0013d2c:	48 89 5c 24 18       	mov    QWORD PTR [rsp+0x18],rbx
ffffffffc0013d31:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc0013d38:	00 00 
ffffffffc0013d3a:	48 89 6c 24 38       	mov    QWORD PTR [rsp+0x38],rbp
ffffffffc0013d3f:	48 89 6c 24 20       	mov    QWORD PTR [rsp+0x20],rbp
ffffffffc0013d44:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
ffffffffc0013d49:	48 89 44 24 40       	mov    QWORD PTR [rsp+0x40],rax
ffffffffc0013d4e:	31 c0                	xor    eax,eax
ffffffffc0013d50:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
ffffffffc0013d55:	66 66 2e 0f 1f 84 00 	data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0013d5c:	00 00 00 00 
ffffffffc0013d60:	48 89 ef             	mov    rdi,rbp
ffffffffc0013d63:	e8 78 06 00 00       	call   ffffffffc00143e0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E>
ffffffffc0013d68:	48 89 c3             	mov    rbx,rax
ffffffffc0013d6b:	41 89 d7             	mov    r15d,edx
ffffffffc0013d6e:	89 d0                	mov    eax,edx
ffffffffc0013d70:	83 fa 22             	cmp    edx,0x22
ffffffffc0013d73:	77 1b                	ja     ffffffffc0013d90 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0xb0>
ffffffffc0013d75:	ff 24 c5 d0 74 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8b30]
ffffffffc0013d7c:	bd 02 00 00 00       	mov    ebp,0x2
ffffffffc0013d81:	c7 44 24 0c 30 00 00 	mov    DWORD PTR [rsp+0xc],0x30
ffffffffc0013d88:	00 
ffffffffc0013d89:	e9 7e 00 00 00       	jmp    ffffffffc0013e0c <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x12c>
ffffffffc0013d8e:	66 90                	xchg   ax,ax
ffffffffc0013d90:	41 83 ff 5c          	cmp    r15d,0x5c
ffffffffc0013d94:	74 3f                	je     ffffffffc0013dd5 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0xf5>
ffffffffc0013d96:	41 81 ff 00 00 11 00 	cmp    r15d,0x110000
ffffffffc0013d9d:	0f 84 17 02 00 00    	je     ffffffffc0013fba <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x2da>
ffffffffc0013da3:	44 89 ff             	mov    edi,r15d
ffffffffc0013da6:	e8 c5 1e 00 00       	call   ffffffffc0015c70 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE>
ffffffffc0013dab:	84 c0                	test   al,al
ffffffffc0013dad:	75 0c                	jne    ffffffffc0013dbb <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0xdb>
ffffffffc0013daf:	44 89 ff             	mov    edi,r15d
ffffffffc0013db2:	e8 29 13 00 00       	call   ffffffffc00150e0 <_ZN4core7unicode9printable12is_printable17hd24752249c0f9d67E>
ffffffffc0013db7:	84 c0                	test   al,al
ffffffffc0013db9:	75 a5                	jne    ffffffffc0013d60 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x80>
ffffffffc0013dbb:	44 89 f8             	mov    eax,r15d
ffffffffc0013dbe:	bd 03 00 00 00       	mov    ebp,0x3
ffffffffc0013dc3:	83 c8 01             	or     eax,0x1
ffffffffc0013dc6:	f3 44 0f bd f0       	lzcnt  r14d,eax
ffffffffc0013dcb:	41 c1 ee 02          	shr    r14d,0x2
ffffffffc0013dcf:	41 83 f6 07          	xor    r14d,0x7
ffffffffc0013dd3:	eb 37                	jmp    ffffffffc0013e0c <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x12c>
ffffffffc0013dd5:	bd 02 00 00 00       	mov    ebp,0x2
ffffffffc0013dda:	44 89 7c 24 0c       	mov    DWORD PTR [rsp+0xc],r15d
ffffffffc0013ddf:	eb 2b                	jmp    ffffffffc0013e0c <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x12c>
ffffffffc0013de1:	bd 02 00 00 00       	mov    ebp,0x2
ffffffffc0013de6:	c7 44 24 0c 74 00 00 	mov    DWORD PTR [rsp+0xc],0x74
ffffffffc0013ded:	00 
ffffffffc0013dee:	eb 1c                	jmp    ffffffffc0013e0c <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x12c>
ffffffffc0013df0:	bd 02 00 00 00       	mov    ebp,0x2
ffffffffc0013df5:	c7 44 24 0c 6e 00 00 	mov    DWORD PTR [rsp+0xc],0x6e
ffffffffc0013dfc:	00 
ffffffffc0013dfd:	eb 0d                	jmp    ffffffffc0013e0c <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x12c>
ffffffffc0013dff:	bd 02 00 00 00       	mov    ebp,0x2
ffffffffc0013e04:	c7 44 24 0c 72 00 00 	mov    DWORD PTR [rsp+0xc],0x72
ffffffffc0013e0b:	00 
ffffffffc0013e0c:	48 8b 44 24 10       	mov    rax,QWORD PTR [rsp+0x10]
ffffffffc0013e11:	48 8b 7c 24 20       	mov    rdi,QWORD PTR [rsp+0x20]
ffffffffc0013e16:	48 39 d8             	cmp    rax,rbx
ffffffffc0013e19:	0f 87 90 02 00 00    	ja     ffffffffc00140af <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3cf>
ffffffffc0013e1f:	48 8b 74 24 18       	mov    rsi,QWORD PTR [rsp+0x18]
ffffffffc0013e24:	48 85 c0             	test   rax,rax
ffffffffc0013e27:	74 16                	je     ffffffffc0013e3f <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x15f>
ffffffffc0013e29:	48 39 f0             	cmp    rax,rsi
ffffffffc0013e2c:	73 0b                	jae    ffffffffc0013e39 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x159>
ffffffffc0013e2e:	80 3c 07 bf          	cmp    BYTE PTR [rdi+rax*1],0xbf
ffffffffc0013e32:	7f 0b                	jg     ffffffffc0013e3f <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x15f>
ffffffffc0013e34:	e9 7b 02 00 00       	jmp    ffffffffc00140b4 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3d4>
ffffffffc0013e39:	0f 85 75 02 00 00    	jne    ffffffffc00140b4 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3d4>
ffffffffc0013e3f:	48 85 db             	test   rbx,rbx
ffffffffc0013e42:	74 16                	je     ffffffffc0013e5a <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x17a>
ffffffffc0013e44:	48 39 f3             	cmp    rbx,rsi
ffffffffc0013e47:	73 0b                	jae    ffffffffc0013e54 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x174>
ffffffffc0013e49:	80 3c 1f bf          	cmp    BYTE PTR [rdi+rbx*1],0xbf
ffffffffc0013e4d:	7f 0b                	jg     ffffffffc0013e5a <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x17a>
ffffffffc0013e4f:	e9 60 02 00 00       	jmp    ffffffffc00140b4 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3d4>
ffffffffc0013e54:	0f 85 5a 02 00 00    	jne    ffffffffc00140b4 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3d4>
ffffffffc0013e5a:	48 89 da             	mov    rdx,rbx
ffffffffc0013e5d:	48 29 c2             	sub    rdx,rax
ffffffffc0013e60:	0f 82 fb 01 00 00    	jb     ffffffffc0014061 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x381>
ffffffffc0013e66:	48 01 f8             	add    rax,rdi
ffffffffc0013e69:	48 89 5c 24 10       	mov    QWORD PTR [rsp+0x10],rbx
ffffffffc0013e6e:	4c 89 ef             	mov    rdi,r13
ffffffffc0013e71:	48 89 c6             	mov    rsi,rax
ffffffffc0013e74:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
ffffffffc0013e79:	ff 50 18             	call   QWORD PTR [rax+0x18]
ffffffffc0013e7c:	84 c0                	test   al,al
ffffffffc0013e7e:	0f 85 92 fe ff ff    	jne    ffffffffc0013d16 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x36>
ffffffffc0013e84:	89 e8                	mov    eax,ebp
ffffffffc0013e86:	b3 05                	mov    bl,0x5
ffffffffc0013e88:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0013e8d:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0013e92:	89 c0                	mov    eax,eax
ffffffffc0013e94:	ff 24 c5 e8 75 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8a18]
ffffffffc0013e9b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0013ea0:	0f b6 c3             	movzx  eax,bl
ffffffffc0013ea3:	bd 03 00 00 00       	mov    ebp,0x3
ffffffffc0013ea8:	be 7d 00 00 00       	mov    esi,0x7d
ffffffffc0013ead:	31 db                	xor    ebx,ebx
ffffffffc0013eaf:	ff 24 c5 08 76 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe89f8]
ffffffffc0013eb6:	4c 89 f0             	mov    rax,r14
ffffffffc0013eb9:	b9 04 00 00 00       	mov    ecx,0x4
ffffffffc0013ebe:	48 f7 e1             	mul    rcx
ffffffffc0013ec1:	0f 80 66 01 00 00    	jo     ffffffffc001402d <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x34d>
ffffffffc0013ec7:	48 83 f8 20          	cmp    rax,0x20
ffffffffc0013ecb:	0f 83 76 01 00 00    	jae    ffffffffc0014047 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x367>
ffffffffc0013ed1:	49 83 fe 01          	cmp    r14,0x1
ffffffffc0013ed5:	b3 02                	mov    bl,0x2
ffffffffc0013ed7:	b9 00 00 00 00       	mov    ecx,0x0
ffffffffc0013edc:	80 db 00             	sbb    bl,0x0
ffffffffc0013edf:	49 83 ee 01          	sub    r14,0x1
ffffffffc0013ee3:	4c 0f 42 f1          	cmovb  r14,rcx
ffffffffc0013ee7:	24 1c                	and    al,0x1c
ffffffffc0013ee9:	c4 c2 7b f7 c7       	shrx   eax,r15d,eax
ffffffffc0013eee:	24 0f                	and    al,0xf
ffffffffc0013ef0:	8d 48 30             	lea    ecx,[rax+0x30]
ffffffffc0013ef3:	8d 50 57             	lea    edx,[rax+0x57]
ffffffffc0013ef6:	3c 0a                	cmp    al,0xa
ffffffffc0013ef8:	0f b6 c1             	movzx  eax,cl
ffffffffc0013efb:	0f b6 ca             	movzx  ecx,dl
ffffffffc0013efe:	0f 42 c8             	cmovb  ecx,eax
ffffffffc0013f01:	0f b6 f1             	movzx  esi,cl
ffffffffc0013f04:	eb 4a                	jmp    ffffffffc0013f50 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x270>
ffffffffc0013f06:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0013f0d:	00 00 00 
ffffffffc0013f10:	b3 02                	mov    bl,0x2
ffffffffc0013f12:	be 7b 00 00 00       	mov    esi,0x7b
ffffffffc0013f17:	eb 37                	jmp    ffffffffc0013f50 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x270>
ffffffffc0013f19:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc0013f20:	b3 04                	mov    bl,0x4
ffffffffc0013f22:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0013f27:	eb 27                	jmp    ffffffffc0013f50 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x270>
ffffffffc0013f29:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc0013f30:	b3 03                	mov    bl,0x3
ffffffffc0013f32:	be 75 00 00 00       	mov    esi,0x75
ffffffffc0013f37:	eb 17                	jmp    ffffffffc0013f50 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x270>
ffffffffc0013f39:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc0013f40:	8b 74 24 0c          	mov    esi,DWORD PTR [rsp+0xc]
ffffffffc0013f44:	31 ed                	xor    ebp,ebp
ffffffffc0013f46:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0013f4d:	00 00 00 
ffffffffc0013f50:	4c 89 ef             	mov    rdi,r13
ffffffffc0013f53:	41 ff d4             	call   r12
ffffffffc0013f56:	84 c0                	test   al,al
ffffffffc0013f58:	0f 85 b8 fd ff ff    	jne    ffffffffc0013d16 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x36>
ffffffffc0013f5e:	89 e8                	mov    eax,ebp
ffffffffc0013f60:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0013f65:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0013f6a:	ff 24 c5 e8 75 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8a18]
ffffffffc0013f71:	b8 01 00 00 00       	mov    eax,0x1
ffffffffc0013f76:	41 81 ff 80 00 00 00 	cmp    r15d,0x80
ffffffffc0013f7d:	72 1e                	jb     ffffffffc0013f9d <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x2bd>
ffffffffc0013f7f:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0013f84:	41 81 ff 00 08 00 00 	cmp    r15d,0x800
ffffffffc0013f8b:	72 10                	jb     ffffffffc0013f9d <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x2bd>
ffffffffc0013f8d:	41 81 ff 00 00 01 00 	cmp    r15d,0x10000
ffffffffc0013f94:	b8 04 00 00 00       	mov    eax,0x4
ffffffffc0013f99:	48 83 d8 00          	sbb    rax,0x0
ffffffffc0013f9d:	48 8b 5c 24 10       	mov    rbx,QWORD PTR [rsp+0x10]
ffffffffc0013fa2:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
ffffffffc0013fa7:	48 01 c3             	add    rbx,rax
ffffffffc0013faa:	0f 82 cb 00 00 00    	jb     ffffffffc001407b <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x39b>
ffffffffc0013fb0:	48 89 5c 24 10       	mov    QWORD PTR [rsp+0x10],rbx
ffffffffc0013fb5:	e9 a6 fd ff ff       	jmp    ffffffffc0013d60 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x80>
ffffffffc0013fba:	48 8b 54 24 10       	mov    rdx,QWORD PTR [rsp+0x10]
ffffffffc0013fbf:	48 85 d2             	test   rdx,rdx
ffffffffc0013fc2:	74 1a                	je     ffffffffc0013fde <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x2fe>
ffffffffc0013fc4:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
ffffffffc0013fc9:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
ffffffffc0013fce:	48 39 ca             	cmp    rdx,rcx
ffffffffc0013fd1:	73 17                	jae    ffffffffc0013fea <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x30a>
ffffffffc0013fd3:	80 3c 16 bf          	cmp    BYTE PTR [rsi+rdx*1],0xbf
ffffffffc0013fd7:	7f 17                	jg     ffffffffc0013ff0 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x310>
ffffffffc0013fd9:	e9 ea 00 00 00       	jmp    ffffffffc00140c8 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3e8>
ffffffffc0013fde:	48 8b 4c 24 18       	mov    rcx,QWORD PTR [rsp+0x18]
ffffffffc0013fe3:	48 8b 74 24 20       	mov    rsi,QWORD PTR [rsp+0x20]
ffffffffc0013fe8:	eb 06                	jmp    ffffffffc0013ff0 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x310>
ffffffffc0013fea:	0f 85 d8 00 00 00    	jne    ffffffffc00140c8 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3e8>
ffffffffc0013ff0:	48 29 d1             	sub    rcx,rdx
ffffffffc0013ff3:	0f 82 9c 00 00 00    	jb     ffffffffc0014095 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x3b5>
ffffffffc0013ff9:	48 8b 44 24 28       	mov    rax,QWORD PTR [rsp+0x28]
ffffffffc0013ffe:	48 01 d6             	add    rsi,rdx
ffffffffc0014001:	4c 89 ef             	mov    rdi,r13
ffffffffc0014004:	48 89 ca             	mov    rdx,rcx
ffffffffc0014007:	ff 50 18             	call   QWORD PTR [rax+0x18]
ffffffffc001400a:	84 c0                	test   al,al
ffffffffc001400c:	0f 85 04 fd ff ff    	jne    ffffffffc0013d16 <_ZN40_$LT$str$u20$as$u20$core..fmt..Debug$GT$3fmt17ha9a8223f0c14d8a1E+0x36>
ffffffffc0014012:	4c 89 ef             	mov    rdi,r13
ffffffffc0014015:	be 22 00 00 00       	mov    esi,0x22
ffffffffc001401a:	4c 89 e0             	mov    rax,r12
ffffffffc001401d:	48 83 c4 48          	add    rsp,0x48
ffffffffc0014021:	5b                   	pop    rbx
ffffffffc0014022:	41 5c                	pop    r12
ffffffffc0014024:	41 5d                	pop    r13
ffffffffc0014026:	41 5e                	pop    r14
ffffffffc0014028:	41 5f                	pop    r15
ffffffffc001402a:	5d                   	pop    rbp
ffffffffc001402b:	ff e0                	jmp    rax
ffffffffc001402d:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0014032:	48 c7 c7 90 7c 01 c0 	mov    rdi,0xffffffffc0017c90
ffffffffc0014039:	48 c7 c2 50 7d 01 c0 	mov    rdx,0xffffffffc0017d50
ffffffffc0014040:	e8 eb 05 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014045:	0f 0b                	ud2    
ffffffffc0014047:	be 24 00 00 00       	mov    esi,0x24
ffffffffc001404c:	48 c7 c7 80 7d 01 c0 	mov    rdi,0xffffffffc0017d80
ffffffffc0014053:	48 c7 c2 68 7d 01 c0 	mov    rdx,0xffffffffc0017d68
ffffffffc001405a:	e8 d1 05 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001405f:	0f 0b                	ud2    
ffffffffc0014061:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0014066:	48 c7 c7 60 78 01 c0 	mov    rdi,0xffffffffc0017860
ffffffffc001406d:	48 c7 c2 a0 7b 01 c0 	mov    rdx,0xffffffffc0017ba0
ffffffffc0014074:	e8 b7 05 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014079:	0f 0b                	ud2    
ffffffffc001407b:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014080:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc0014087:	48 c7 c2 50 7a 01 c0 	mov    rdx,0xffffffffc0017a50
ffffffffc001408e:	e8 9d 05 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014093:	0f 0b                	ud2    
ffffffffc0014095:	be 21 00 00 00       	mov    esi,0x21
ffffffffc001409a:	48 c7 c7 60 78 01 c0 	mov    rdi,0xffffffffc0017860
ffffffffc00140a1:	48 c7 c2 b8 7b 01 c0 	mov    rdx,0xffffffffc0017bb8
ffffffffc00140a8:	e8 83 05 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00140ad:	0f 0b                	ud2    
ffffffffc00140af:	48 8b 74 24 18       	mov    rsi,QWORD PTR [rsp+0x18]
ffffffffc00140b4:	48 89 c2             	mov    rdx,rax
ffffffffc00140b7:	48 89 d9             	mov    rcx,rbx
ffffffffc00140ba:	49 c7 c0 38 7a 01 c0 	mov    r8,0xffffffffc0017a38
ffffffffc00140c1:	e8 3a 17 00 00       	call   ffffffffc0015800 <_ZN4core3str16slice_error_fail17h5f3f742159a9ffe5E>
ffffffffc00140c6:	0f 0b                	ud2    
ffffffffc00140c8:	48 89 f7             	mov    rdi,rsi
ffffffffc00140cb:	48 89 ce             	mov    rsi,rcx
ffffffffc00140ce:	49 c7 c0 68 7a 01 c0 	mov    r8,0xffffffffc0017a68
ffffffffc00140d5:	e8 26 17 00 00       	call   ffffffffc0015800 <_ZN4core3str16slice_error_fail17h5f3f742159a9ffe5E>
ffffffffc00140da:	0f 0b                	ud2    
ffffffffc00140dc:	cc                   	int3   
ffffffffc00140dd:	cc                   	int3   
ffffffffc00140de:	cc                   	int3   
ffffffffc00140df:	cc                   	int3   

ffffffffc00140e0 <_ZN42_$LT$str$u20$as$u20$core..fmt..Display$GT$3fmt17h779539b9b1a83356E>:
ffffffffc00140e0:	48 89 d0             	mov    rax,rdx
ffffffffc00140e3:	48 89 f2             	mov    rdx,rsi
ffffffffc00140e6:	48 89 fe             	mov    rsi,rdi
ffffffffc00140e9:	48 89 c7             	mov    rdi,rax
ffffffffc00140ec:	e9 6f f9 ff ff       	jmp    ffffffffc0013a60 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E>
ffffffffc00140f1:	cc                   	int3   
ffffffffc00140f2:	cc                   	int3   
ffffffffc00140f3:	cc                   	int3   
ffffffffc00140f4:	cc                   	int3   
ffffffffc00140f5:	cc                   	int3   
ffffffffc00140f6:	cc                   	int3   
ffffffffc00140f7:	cc                   	int3   
ffffffffc00140f8:	cc                   	int3   
ffffffffc00140f9:	cc                   	int3   
ffffffffc00140fa:	cc                   	int3   
ffffffffc00140fb:	cc                   	int3   
ffffffffc00140fc:	cc                   	int3   
ffffffffc00140fd:	cc                   	int3   
ffffffffc00140fe:	cc                   	int3   
ffffffffc00140ff:	cc                   	int3   

ffffffffc0014100 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE>:
ffffffffc0014100:	55                   	push   rbp
ffffffffc0014101:	41 57                	push   r15
ffffffffc0014103:	41 56                	push   r14
ffffffffc0014105:	41 55                	push   r13
ffffffffc0014107:	41 54                	push   r12
ffffffffc0014109:	53                   	push   rbx
ffffffffc001410a:	48 83 ec 08          	sub    rsp,0x8
ffffffffc001410e:	48 8b 46 28          	mov    rax,QWORD PTR [rsi+0x28]
ffffffffc0014112:	4c 8b 6e 20          	mov    r13,QWORD PTR [rsi+0x20]
ffffffffc0014116:	49 89 fe             	mov    r14,rdi
ffffffffc0014119:	be 27 00 00 00       	mov    esi,0x27
ffffffffc001411e:	48 8b 40 20          	mov    rax,QWORD PTR [rax+0x20]
ffffffffc0014122:	4c 89 ef             	mov    rdi,r13
ffffffffc0014125:	49 89 c4             	mov    r12,rax
ffffffffc0014128:	ff d0                	call   rax
ffffffffc001412a:	84 c0                	test   al,al
ffffffffc001412c:	74 11                	je     ffffffffc001413f <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x3f>
ffffffffc001412e:	b0 01                	mov    al,0x1
ffffffffc0014130:	48 83 c4 08          	add    rsp,0x8
ffffffffc0014134:	5b                   	pop    rbx
ffffffffc0014135:	41 5c                	pop    r12
ffffffffc0014137:	41 5d                	pop    r13
ffffffffc0014139:	41 5e                	pop    r14
ffffffffc001413b:	41 5f                	pop    r15
ffffffffc001413d:	5d                   	pop    rbp
ffffffffc001413e:	c3                   	ret    
ffffffffc001413f:	41 8b 1e             	mov    ebx,DWORD PTR [r14]
ffffffffc0014142:	41 be 30 00 00 00    	mov    r14d,0x30
ffffffffc0014148:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc001414d:	48 89 1c 24          	mov    QWORD PTR [rsp],rbx
ffffffffc0014151:	48 83 fb 27          	cmp    rbx,0x27
ffffffffc0014155:	77 27                	ja     ffffffffc001417e <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x7e>
ffffffffc0014157:	ff 24 dd 38 76 01 c0 	jmp    QWORD PTR [rbx*8-0x3ffe89c8]
ffffffffc001415e:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0014163:	41 be 74 00 00 00    	mov    r14d,0x74
ffffffffc0014169:	b3 05                	mov    bl,0x5
ffffffffc001416b:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0014170:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0014175:	89 c0                	mov    eax,eax
ffffffffc0014177:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc001417e:	83 fb 5c             	cmp    ebx,0x5c
ffffffffc0014181:	75 20                	jne    ffffffffc00141a3 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0xa3>
ffffffffc0014183:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0014188:	48 89 da             	mov    rdx,rbx
ffffffffc001418b:	b3 05                	mov    bl,0x5
ffffffffc001418d:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0014192:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0014197:	89 c0                	mov    eax,eax
ffffffffc0014199:	41 89 d6             	mov    r14d,edx
ffffffffc001419c:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc00141a3:	89 df                	mov    edi,ebx
ffffffffc00141a5:	e8 c6 1a 00 00       	call   ffffffffc0015c70 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE>
ffffffffc00141aa:	84 c0                	test   al,al
ffffffffc00141ac:	0f 84 8c 00 00 00    	je     ffffffffc001423e <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x13e>
ffffffffc00141b2:	89 d8                	mov    eax,ebx
ffffffffc00141b4:	b3 05                	mov    bl,0x5
ffffffffc00141b6:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc00141bb:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc00141c0:	83 c8 01             	or     eax,0x1
ffffffffc00141c3:	f3 44 0f bd f8       	lzcnt  r15d,eax
ffffffffc00141c8:	b8 03 00 00 00       	mov    eax,0x3
ffffffffc00141cd:	89 c0                	mov    eax,eax
ffffffffc00141cf:	41 c1 ef 02          	shr    r15d,0x2
ffffffffc00141d3:	41 83 f7 07          	xor    r15d,0x7
ffffffffc00141d7:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc00141de:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc00141e3:	41 be 6e 00 00 00    	mov    r14d,0x6e
ffffffffc00141e9:	b3 05                	mov    bl,0x5
ffffffffc00141eb:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc00141f0:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc00141f5:	89 c0                	mov    eax,eax
ffffffffc00141f7:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc00141fe:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0014203:	41 be 72 00 00 00    	mov    r14d,0x72
ffffffffc0014209:	b3 05                	mov    bl,0x5
ffffffffc001420b:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0014210:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0014215:	89 c0                	mov    eax,eax
ffffffffc0014217:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc001421e:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0014223:	48 89 da             	mov    rdx,rbx
ffffffffc0014226:	b3 05                	mov    bl,0x5
ffffffffc0014228:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc001422d:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0014232:	89 c0                	mov    eax,eax
ffffffffc0014234:	41 89 d6             	mov    r14d,edx
ffffffffc0014237:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc001423e:	89 df                	mov    edi,ebx
ffffffffc0014240:	e8 9b 0e 00 00       	call   ffffffffc00150e0 <_ZN4core7unicode9printable12is_printable17hd24752249c0f9d67E>
ffffffffc0014245:	b9 01 00 00 00       	mov    ecx,0x1
ffffffffc001424a:	41 89 de             	mov    r14d,ebx
ffffffffc001424d:	84 c0                	test   al,al
ffffffffc001424f:	75 17                	jne    ffffffffc0014268 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x168>
ffffffffc0014251:	89 d8                	mov    eax,ebx
ffffffffc0014253:	b9 03 00 00 00       	mov    ecx,0x3
ffffffffc0014258:	83 c8 01             	or     eax,0x1
ffffffffc001425b:	f3 44 0f bd f8       	lzcnt  r15d,eax
ffffffffc0014260:	41 c1 ef 02          	shr    r15d,0x2
ffffffffc0014264:	41 83 f7 07          	xor    r15d,0x7
ffffffffc0014268:	89 c8                	mov    eax,ecx
ffffffffc001426a:	b3 05                	mov    bl,0x5
ffffffffc001426c:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc0014271:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0014276:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc001427d:	0f 1f 00             	nop    DWORD PTR [rax]
ffffffffc0014280:	4c 89 ef             	mov    rdi,r13
ffffffffc0014283:	41 ff d4             	call   r12
ffffffffc0014286:	84 c0                	test   al,al
ffffffffc0014288:	0f 85 a0 fe ff ff    	jne    ffffffffc001412e <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x2e>
ffffffffc001428e:	89 e8                	mov    eax,ebp
ffffffffc0014290:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc0014295:	bd 01 00 00 00       	mov    ebp,0x1
ffffffffc001429a:	ff 24 c5 78 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8888]
ffffffffc00142a1:	31 ed                	xor    ebp,ebp
ffffffffc00142a3:	44 89 f6             	mov    esi,r14d
ffffffffc00142a6:	eb d8                	jmp    ffffffffc0014280 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x180>
ffffffffc00142a8:	0f b6 c3             	movzx  eax,bl
ffffffffc00142ab:	bd 03 00 00 00       	mov    ebp,0x3
ffffffffc00142b0:	be 7d 00 00 00       	mov    esi,0x7d
ffffffffc00142b5:	31 db                	xor    ebx,ebx
ffffffffc00142b7:	ff 24 c5 98 77 01 c0 	jmp    QWORD PTR [rax*8-0x3ffe8868]
ffffffffc00142be:	b9 04 00 00 00       	mov    ecx,0x4
ffffffffc00142c3:	4c 89 f8             	mov    rax,r15
ffffffffc00142c6:	48 f7 e1             	mul    rcx
ffffffffc00142c9:	70 7f                	jo     ffffffffc001434a <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x24a>
ffffffffc00142cb:	48 83 f8 20          	cmp    rax,0x20
ffffffffc00142cf:	0f 83 8f 00 00 00    	jae    ffffffffc0014364 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x264>
ffffffffc00142d5:	49 83 ff 01          	cmp    r15,0x1
ffffffffc00142d9:	b3 02                	mov    bl,0x2
ffffffffc00142db:	80 db 00             	sbb    bl,0x0
ffffffffc00142de:	31 c9                	xor    ecx,ecx
ffffffffc00142e0:	49 83 ef 01          	sub    r15,0x1
ffffffffc00142e4:	4c 0f 42 f9          	cmovb  r15,rcx
ffffffffc00142e8:	24 1c                	and    al,0x1c
ffffffffc00142ea:	c4 e2 7b f7 04 24    	shrx   eax,DWORD PTR [rsp],eax
ffffffffc00142f0:	24 0f                	and    al,0xf
ffffffffc00142f2:	8d 48 30             	lea    ecx,[rax+0x30]
ffffffffc00142f5:	8d 50 57             	lea    edx,[rax+0x57]
ffffffffc00142f8:	3c 0a                	cmp    al,0xa
ffffffffc00142fa:	0f b6 c1             	movzx  eax,cl
ffffffffc00142fd:	0f b6 ca             	movzx  ecx,dl
ffffffffc0014300:	0f 42 c8             	cmovb  ecx,eax
ffffffffc0014303:	0f b6 f1             	movzx  esi,cl
ffffffffc0014306:	e9 75 ff ff ff       	jmp    ffffffffc0014280 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x180>
ffffffffc001430b:	b3 02                	mov    bl,0x2
ffffffffc001430d:	be 7b 00 00 00       	mov    esi,0x7b
ffffffffc0014312:	e9 69 ff ff ff       	jmp    ffffffffc0014280 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x180>
ffffffffc0014317:	b3 03                	mov    bl,0x3
ffffffffc0014319:	be 75 00 00 00       	mov    esi,0x75
ffffffffc001431e:	e9 5d ff ff ff       	jmp    ffffffffc0014280 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x180>
ffffffffc0014323:	b3 04                	mov    bl,0x4
ffffffffc0014325:	be 5c 00 00 00       	mov    esi,0x5c
ffffffffc001432a:	e9 51 ff ff ff       	jmp    ffffffffc0014280 <_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h6d48a1d2a26ec68bE+0x180>
ffffffffc001432f:	4c 89 ef             	mov    rdi,r13
ffffffffc0014332:	be 27 00 00 00       	mov    esi,0x27
ffffffffc0014337:	4c 89 e0             	mov    rax,r12
ffffffffc001433a:	48 83 c4 08          	add    rsp,0x8
ffffffffc001433e:	5b                   	pop    rbx
ffffffffc001433f:	41 5c                	pop    r12
ffffffffc0014341:	41 5d                	pop    r13
ffffffffc0014343:	41 5e                	pop    r14
ffffffffc0014345:	41 5f                	pop    r15
ffffffffc0014347:	5d                   	pop    rbp
ffffffffc0014348:	ff e0                	jmp    rax
ffffffffc001434a:	be 21 00 00 00       	mov    esi,0x21
ffffffffc001434f:	48 c7 c7 90 7c 01 c0 	mov    rdi,0xffffffffc0017c90
ffffffffc0014356:	48 c7 c2 50 7d 01 c0 	mov    rdx,0xffffffffc0017d50
ffffffffc001435d:	e8 ce 02 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014362:	0f 0b                	ud2    
ffffffffc0014364:	be 24 00 00 00       	mov    esi,0x24
ffffffffc0014369:	48 c7 c7 80 7d 01 c0 	mov    rdi,0xffffffffc0017d80
ffffffffc0014370:	48 c7 c2 68 7d 01 c0 	mov    rdx,0xffffffffc0017d68
ffffffffc0014377:	e8 b4 02 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001437c:	0f 0b                	ud2    
ffffffffc001437e:	cc                   	int3   
ffffffffc001437f:	cc                   	int3   

ffffffffc0014380 <_ZN54_$LT$$BP$const$u20$T$u20$as$u20$core..fmt..Pointer$GT$3fmt5inner17hdd56e846e6855501E>:
ffffffffc0014380:	55                   	push   rbp
ffffffffc0014381:	41 57                	push   r15
ffffffffc0014383:	41 56                	push   r14
ffffffffc0014385:	53                   	push   rbx
ffffffffc0014386:	48 83 ec 08          	sub    rsp,0x8
ffffffffc001438a:	8b 6e 30             	mov    ebp,DWORD PTR [rsi+0x30]
ffffffffc001438d:	4c 8b 36             	mov    r14,QWORD PTR [rsi]
ffffffffc0014390:	4c 8b 7e 08          	mov    r15,QWORD PTR [rsi+0x8]
ffffffffc0014394:	48 89 f3             	mov    rbx,rsi
ffffffffc0014397:	89 e8                	mov    eax,ebp
ffffffffc0014399:	40 f6 c5 04          	test   bpl,0x4
ffffffffc001439d:	74 19                	je     ffffffffc00143b8 <_ZN54_$LT$$BP$const$u20$T$u20$as$u20$core..fmt..Pointer$GT$3fmt5inner17hdd56e846e6855501E+0x38>
ffffffffc001439f:	89 e8                	mov    eax,ebp
ffffffffc00143a1:	83 c8 08             	or     eax,0x8
ffffffffc00143a4:	4d 85 f6             	test   r14,r14
ffffffffc00143a7:	75 0f                	jne    ffffffffc00143b8 <_ZN54_$LT$$BP$const$u20$T$u20$as$u20$core..fmt..Pointer$GT$3fmt5inner17hdd56e846e6855501E+0x38>
ffffffffc00143a9:	48 c7 03 01 00 00 00 	mov    QWORD PTR [rbx],0x1
ffffffffc00143b0:	48 c7 43 08 12 00 00 	mov    QWORD PTR [rbx+0x8],0x12
ffffffffc00143b7:	00 
ffffffffc00143b8:	83 c8 04             	or     eax,0x4
ffffffffc00143bb:	48 89 de             	mov    rsi,rbx
ffffffffc00143be:	89 43 30             	mov    DWORD PTR [rbx+0x30],eax
ffffffffc00143c1:	e8 7a ec ff ff       	call   ffffffffc0013040 <_ZN4core3fmt3num12GenericRadix7fmt_int17h687cf171525b98aaE.llvm.17464636063181802738>
ffffffffc00143c6:	4c 89 33             	mov    QWORD PTR [rbx],r14
ffffffffc00143c9:	4c 89 7b 08          	mov    QWORD PTR [rbx+0x8],r15
ffffffffc00143cd:	89 6b 30             	mov    DWORD PTR [rbx+0x30],ebp
ffffffffc00143d0:	48 83 c4 08          	add    rsp,0x8
ffffffffc00143d4:	5b                   	pop    rbx
ffffffffc00143d5:	41 5e                	pop    r14
ffffffffc00143d7:	41 5f                	pop    r15
ffffffffc00143d9:	5d                   	pop    rbp
ffffffffc00143da:	c3                   	ret    
ffffffffc00143db:	cc                   	int3   
ffffffffc00143dc:	cc                   	int3   
ffffffffc00143dd:	cc                   	int3   
ffffffffc00143de:	cc                   	int3   
ffffffffc00143df:	cc                   	int3   

ffffffffc00143e0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E>:
ffffffffc00143e0:	48 83 ec 08          	sub    rsp,0x8
ffffffffc00143e4:	48 8b 47 10          	mov    rax,QWORD PTR [rdi+0x10]
ffffffffc00143e8:	48 8b 77 08          	mov    rsi,QWORD PTR [rdi+0x8]
ffffffffc00143ec:	48 89 c1             	mov    rcx,rax
ffffffffc00143ef:	48 29 f1             	sub    rcx,rsi
ffffffffc00143f2:	0f 84 8b 00 00 00    	je     ffffffffc0014483 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xa3>
ffffffffc00143f8:	4c 8d 4e 01          	lea    r9,[rsi+0x1]
ffffffffc00143fc:	4c 89 4f 08          	mov    QWORD PTR [rdi+0x8],r9
ffffffffc0014400:	0f b6 16             	movzx  edx,BYTE PTR [rsi]
ffffffffc0014403:	84 d2                	test   dl,dl
ffffffffc0014405:	0f 89 95 00 00 00    	jns    ffffffffc00144a0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xc0>
ffffffffc001440b:	49 39 c1             	cmp    r9,rax
ffffffffc001440e:	0f 84 0d 01 00 00    	je     ffffffffc0014521 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0x141>
ffffffffc0014414:	4c 8d 4e 02          	lea    r9,[rsi+0x2]
ffffffffc0014418:	41 89 d0             	mov    r8d,edx
ffffffffc001441b:	4c 89 4f 08          	mov    QWORD PTR [rdi+0x8],r9
ffffffffc001441f:	41 83 e0 1f          	and    r8d,0x1f
ffffffffc0014423:	44 0f b6 5e 01       	movzx  r11d,BYTE PTR [rsi+0x1]
ffffffffc0014428:	41 83 e3 3f          	and    r11d,0x3f
ffffffffc001442c:	80 fa df             	cmp    dl,0xdf
ffffffffc001442f:	76 59                	jbe    ffffffffc001448a <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xaa>
ffffffffc0014431:	49 39 c1             	cmp    r9,rax
ffffffffc0014434:	0f 84 01 01 00 00    	je     ffffffffc001453b <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0x15b>
ffffffffc001443a:	4c 8d 4e 03          	lea    r9,[rsi+0x3]
ffffffffc001443e:	41 c1 e3 06          	shl    r11d,0x6
ffffffffc0014442:	4c 89 4f 08          	mov    QWORD PTR [rdi+0x8],r9
ffffffffc0014446:	44 0f b6 56 02       	movzx  r10d,BYTE PTR [rsi+0x2]
ffffffffc001444b:	41 83 e2 3f          	and    r10d,0x3f
ffffffffc001444f:	45 09 da             	or     r10d,r11d
ffffffffc0014452:	80 fa f0             	cmp    dl,0xf0
ffffffffc0014455:	72 3f                	jb     ffffffffc0014496 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xb6>
ffffffffc0014457:	49 39 c1             	cmp    r9,rax
ffffffffc001445a:	0f 84 f5 00 00 00    	je     ffffffffc0014555 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0x175>
ffffffffc0014460:	4c 8d 4e 04          	lea    r9,[rsi+0x4]
ffffffffc0014464:	41 83 e0 07          	and    r8d,0x7
ffffffffc0014468:	41 c1 e2 06          	shl    r10d,0x6
ffffffffc001446c:	4c 89 4f 08          	mov    QWORD PTR [rdi+0x8],r9
ffffffffc0014470:	41 c1 e0 12          	shl    r8d,0x12
ffffffffc0014474:	0f b6 56 03          	movzx  edx,BYTE PTR [rsi+0x3]
ffffffffc0014478:	83 e2 3f             	and    edx,0x3f
ffffffffc001447b:	44 09 d2             	or     edx,r10d
ffffffffc001447e:	44 09 c2             	or     edx,r8d
ffffffffc0014481:	eb 1d                	jmp    ffffffffc00144a0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xc0>
ffffffffc0014483:	ba 00 00 11 00       	mov    edx,0x110000
ffffffffc0014488:	59                   	pop    rcx
ffffffffc0014489:	c3                   	ret    
ffffffffc001448a:	41 c1 e0 06          	shl    r8d,0x6
ffffffffc001448e:	45 09 d8             	or     r8d,r11d
ffffffffc0014491:	44 89 c2             	mov    edx,r8d
ffffffffc0014494:	eb 0a                	jmp    ffffffffc00144a0 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xc0>
ffffffffc0014496:	41 c1 e0 0c          	shl    r8d,0xc
ffffffffc001449a:	45 09 c2             	or     r10d,r8d
ffffffffc001449d:	44 89 d2             	mov    edx,r10d
ffffffffc00144a0:	89 d6                	mov    esi,edx
ffffffffc00144a2:	81 f6 00 d8 00 00    	xor    esi,0xd800
ffffffffc00144a8:	81 c6 00 00 ef ff    	add    esi,0xffef0000
ffffffffc00144ae:	81 fe 00 08 ef ff    	cmp    esi,0xffef0800
ffffffffc00144b4:	72 51                	jb     ffffffffc0014507 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0x127>
ffffffffc00144b6:	81 fa 00 00 11 00    	cmp    edx,0x110000
ffffffffc00144bc:	74 49                	je     ffffffffc0014507 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0x127>
ffffffffc00144be:	4c 29 c8             	sub    rax,r9
ffffffffc00144c1:	48 29 c1             	sub    rcx,rax
ffffffffc00144c4:	72 0d                	jb     ffffffffc00144d3 <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0xf3>
ffffffffc00144c6:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc00144c9:	48 01 c1             	add    rcx,rax
ffffffffc00144cc:	72 1f                	jb     ffffffffc00144ed <_ZN87_$LT$core..str..iter..CharIndices$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hb1d7485502cde487E+0x10d>
ffffffffc00144ce:	48 89 0f             	mov    QWORD PTR [rdi],rcx
ffffffffc00144d1:	59                   	pop    rcx
ffffffffc00144d2:	c3                   	ret    
ffffffffc00144d3:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00144d8:	48 c7 c7 60 78 01 c0 	mov    rdi,0xffffffffc0017860
ffffffffc00144df:	48 c7 c2 f8 7a 01 c0 	mov    rdx,0xffffffffc0017af8
ffffffffc00144e6:	e8 45 01 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00144eb:	0f 0b                	ud2    
ffffffffc00144ed:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00144f2:	48 c7 c7 90 78 01 c0 	mov    rdi,0xffffffffc0017890
ffffffffc00144f9:	48 c7 c2 10 7b 01 c0 	mov    rdx,0xffffffffc0017b10
ffffffffc0014500:	e8 2b 01 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014505:	0f 0b                	ud2    
ffffffffc0014507:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc001450c:	48 c7 c7 ac 78 01 c0 	mov    rdi,0xffffffffc00178ac
ffffffffc0014513:	48 c7 c2 40 78 01 c0 	mov    rdx,0xffffffffc0017840
ffffffffc001451a:	e8 11 01 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001451f:	0f 0b                	ud2    
ffffffffc0014521:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0014526:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc001452d:	48 c7 c2 48 7c 01 c0 	mov    rdx,0xffffffffc0017c48
ffffffffc0014534:	e8 f7 00 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014539:	0f 0b                	ud2    
ffffffffc001453b:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0014540:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc0014547:	48 c7 c2 60 7c 01 c0 	mov    rdx,0xffffffffc0017c60
ffffffffc001454e:	e8 dd 00 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014553:	0f 0b                	ud2    
ffffffffc0014555:	be 20 00 00 00       	mov    esi,0x20
ffffffffc001455a:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc0014561:	48 c7 c2 78 7c 01 c0 	mov    rdx,0xffffffffc0017c78
ffffffffc0014568:	e8 c3 00 00 00       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc001456d:	0f 0b                	ud2    
ffffffffc001456f:	cc                   	int3   

ffffffffc0014570 <_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h03fbf4e04a6cf6beE>:
ffffffffc0014570:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
ffffffffc0014574:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0014577:	48 8b 49 18          	mov    rcx,QWORD PTR [rcx+0x18]
ffffffffc001457b:	48 89 c7             	mov    rdi,rax
ffffffffc001457e:	ff e1                	jmp    rcx

ffffffffc0014580 <_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h0d07617874570f14E>:
ffffffffc0014580:	48 83 ec 38          	sub    rsp,0x38
ffffffffc0014584:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0014587:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
ffffffffc001458b:	48 8b 76 28          	mov    rsi,QWORD PTR [rsi+0x28]
ffffffffc001458f:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0014594:	48 8b 48 28          	mov    rcx,QWORD PTR [rax+0x28]
ffffffffc0014598:	48 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],rcx
ffffffffc001459d:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
ffffffffc00145a1:	48 89 4c 24 28       	mov    QWORD PTR [rsp+0x28],rcx
ffffffffc00145a6:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
ffffffffc00145aa:	48 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],rcx
ffffffffc00145af:	48 8b 48 10          	mov    rcx,QWORD PTR [rax+0x10]
ffffffffc00145b3:	48 89 4c 24 18       	mov    QWORD PTR [rsp+0x18],rcx
ffffffffc00145b8:	48 8b 08             	mov    rcx,QWORD PTR [rax]
ffffffffc00145bb:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
ffffffffc00145bf:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
ffffffffc00145c4:	48 89 4c 24 08       	mov    QWORD PTR [rsp+0x8],rcx
ffffffffc00145c9:	e8 32 ed ff ff       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc00145ce:	48 83 c4 38          	add    rsp,0x38
ffffffffc00145d2:	c3                   	ret    
ffffffffc00145d3:	cc                   	int3   
ffffffffc00145d4:	cc                   	int3   
ffffffffc00145d5:	cc                   	int3   
ffffffffc00145d6:	cc                   	int3   
ffffffffc00145d7:	cc                   	int3   
ffffffffc00145d8:	cc                   	int3   
ffffffffc00145d9:	cc                   	int3   
ffffffffc00145da:	cc                   	int3   
ffffffffc00145db:	cc                   	int3   
ffffffffc00145dc:	cc                   	int3   
ffffffffc00145dd:	cc                   	int3   
ffffffffc00145de:	cc                   	int3   
ffffffffc00145df:	cc                   	int3   

ffffffffc00145e0 <_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h12e1233fa98307c4E>:
ffffffffc00145e0:	48 89 f0             	mov    rax,rsi
ffffffffc00145e3:	48 8b 37             	mov    rsi,QWORD PTR [rdi]
ffffffffc00145e6:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
ffffffffc00145ea:	48 89 c7             	mov    rdi,rax
ffffffffc00145ed:	e9 6e f4 ff ff       	jmp    ffffffffc0013a60 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E>
ffffffffc00145f2:	cc                   	int3   
ffffffffc00145f3:	cc                   	int3   
ffffffffc00145f4:	cc                   	int3   
ffffffffc00145f5:	cc                   	int3   
ffffffffc00145f6:	cc                   	int3   
ffffffffc00145f7:	cc                   	int3   
ffffffffc00145f8:	cc                   	int3   
ffffffffc00145f9:	cc                   	int3   
ffffffffc00145fa:	cc                   	int3   
ffffffffc00145fb:	cc                   	int3   
ffffffffc00145fc:	cc                   	int3   
ffffffffc00145fd:	cc                   	int3   
ffffffffc00145fe:	cc                   	int3   
ffffffffc00145ff:	cc                   	int3   

ffffffffc0014600 <_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hb6560b3c0437eaf9E>:
ffffffffc0014600:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
ffffffffc0014603:	48 89 f0             	mov    rax,rsi
ffffffffc0014606:	48 89 c7             	mov    rdi,rax
ffffffffc0014609:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
ffffffffc001460c:	48 8b 51 08          	mov    rdx,QWORD PTR [rcx+0x8]
ffffffffc0014610:	e9 4b f4 ff ff       	jmp    ffffffffc0013a60 <_ZN4core3fmt9Formatter3pad17hd4b9c948a4ac8729E>
ffffffffc0014615:	cc                   	int3   
ffffffffc0014616:	cc                   	int3   
ffffffffc0014617:	cc                   	int3   
ffffffffc0014618:	cc                   	int3   
ffffffffc0014619:	cc                   	int3   
ffffffffc001461a:	cc                   	int3   
ffffffffc001461b:	cc                   	int3   
ffffffffc001461c:	cc                   	int3   
ffffffffc001461d:	cc                   	int3   
ffffffffc001461e:	cc                   	int3   
ffffffffc001461f:	cc                   	int3   

ffffffffc0014620 <_ZN4core3ptr25drop_in_place$LT$char$GT$17hfa410337715a5ac2E.llvm.10070611248871771183>:
ffffffffc0014620:	c3                   	ret    
ffffffffc0014621:	cc                   	int3   
ffffffffc0014622:	cc                   	int3   
ffffffffc0014623:	cc                   	int3   
ffffffffc0014624:	cc                   	int3   
ffffffffc0014625:	cc                   	int3   
ffffffffc0014626:	cc                   	int3   
ffffffffc0014627:	cc                   	int3   
ffffffffc0014628:	cc                   	int3   
ffffffffc0014629:	cc                   	int3   
ffffffffc001462a:	cc                   	int3   
ffffffffc001462b:	cc                   	int3   
ffffffffc001462c:	cc                   	int3   
ffffffffc001462d:	cc                   	int3   
ffffffffc001462e:	cc                   	int3   
ffffffffc001462f:	cc                   	int3   

ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>:
ffffffffc0014630:	48 83 ec 48          	sub    rsp,0x48
ffffffffc0014634:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0014639:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc001463e:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc0014643:	48 8d 7c 24 18       	lea    rdi,[rsp+0x18]
ffffffffc0014648:	48 89 d6             	mov    rsi,rdx
ffffffffc001464b:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc0014650:	48 c7 44 24 20 01 00 	mov    QWORD PTR [rsp+0x20],0x1
ffffffffc0014657:	00 00 
ffffffffc0014659:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
ffffffffc0014660:	00 00 
ffffffffc0014662:	48 c7 44 24 38 38 7e 	mov    QWORD PTR [rsp+0x38],0xffffffffc0017e38
ffffffffc0014669:	01 c0 
ffffffffc001466b:	48 c7 44 24 40 00 00 	mov    QWORD PTR [rsp+0x40],0x0
ffffffffc0014672:	00 00 
ffffffffc0014674:	e8 87 00 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0014679:	0f 0b                	ud2    
ffffffffc001467b:	cc                   	int3   
ffffffffc001467c:	cc                   	int3   
ffffffffc001467d:	cc                   	int3   
ffffffffc001467e:	cc                   	int3   
ffffffffc001467f:	cc                   	int3   

ffffffffc0014680 <_ZN4core9panicking18panic_bounds_check17hfb23d00fc1893b91E>:
ffffffffc0014680:	48 83 ec 68          	sub    rsp,0x68
ffffffffc0014684:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc0014689:	48 8d 44 24 10       	lea    rax,[rsp+0x10]
ffffffffc001468e:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
ffffffffc0014693:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0014698:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc001469d:	48 8d 7c 24 38       	lea    rdi,[rsp+0x38]
ffffffffc00146a2:	48 c7 44 24 38 70 7e 	mov    QWORD PTR [rsp+0x38],0xffffffffc0017e70
ffffffffc00146a9:	01 c0 
ffffffffc00146ab:	48 c7 44 24 40 02 00 	mov    QWORD PTR [rsp+0x40],0x2
ffffffffc00146b2:	00 00 
ffffffffc00146b4:	48 c7 44 24 48 00 00 	mov    QWORD PTR [rsp+0x48],0x0
ffffffffc00146bb:	00 00 
ffffffffc00146bd:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc00146c2:	48 c7 44 24 20 10 54 	mov    QWORD PTR [rsp+0x20],0xffffffffc0015410
ffffffffc00146c9:	01 c0 
ffffffffc00146cb:	48 89 74 24 28       	mov    QWORD PTR [rsp+0x28],rsi
ffffffffc00146d0:	48 89 d6             	mov    rsi,rdx
ffffffffc00146d3:	48 89 4c 24 58       	mov    QWORD PTR [rsp+0x58],rcx
ffffffffc00146d8:	48 c7 44 24 30 10 54 	mov    QWORD PTR [rsp+0x30],0xffffffffc0015410
ffffffffc00146df:	01 c0 
ffffffffc00146e1:	48 c7 44 24 60 02 00 	mov    QWORD PTR [rsp+0x60],0x2
ffffffffc00146e8:	00 00 
ffffffffc00146ea:	e8 11 00 00 00       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc00146ef:	0f 0b                	ud2    
ffffffffc00146f1:	cc                   	int3   
ffffffffc00146f2:	cc                   	int3   
ffffffffc00146f3:	cc                   	int3   
ffffffffc00146f4:	cc                   	int3   
ffffffffc00146f5:	cc                   	int3   
ffffffffc00146f6:	cc                   	int3   
ffffffffc00146f7:	cc                   	int3   
ffffffffc00146f8:	cc                   	int3   
ffffffffc00146f9:	cc                   	int3   
ffffffffc00146fa:	cc                   	int3   
ffffffffc00146fb:	cc                   	int3   
ffffffffc00146fc:	cc                   	int3   
ffffffffc00146fd:	cc                   	int3   
ffffffffc00146fe:	cc                   	int3   
ffffffffc00146ff:	cc                   	int3   

ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>:
ffffffffc0014700:	48 83 ec 28          	sub    rsp,0x28
ffffffffc0014704:	48 c7 04 24 38 7e 01 	mov    QWORD PTR [rsp],0xffffffffc0017e38
ffffffffc001470b:	c0 
ffffffffc001470c:	48 c7 44 24 08 38 7e 	mov    QWORD PTR [rsp+0x8],0xffffffffc0017e38
ffffffffc0014713:	01 c0 
ffffffffc0014715:	48 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],rdi
ffffffffc001471a:	48 89 e7             	mov    rdi,rsp
ffffffffc001471d:	48 89 74 24 18       	mov    QWORD PTR [rsp+0x18],rsi
ffffffffc0014722:	c6 44 24 20 01       	mov    BYTE PTR [rsp+0x20],0x1
ffffffffc0014727:	e8 d4 c3 ff ff       	call   ffffffffc0010b00 <rust_begin_unwind>
ffffffffc001472c:	0f 0b                	ud2    
ffffffffc001472e:	cc                   	int3   
ffffffffc001472f:	cc                   	int3   

ffffffffc0014730 <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E>:
ffffffffc0014730:	48 81 ec d8 00 00 00 	sub    rsp,0xd8
ffffffffc0014737:	48 89 74 24 18       	mov    QWORD PTR [rsp+0x18],rsi
ffffffffc001473c:	48 89 4c 24 28       	mov    QWORD PTR [rsp+0x28],rcx
ffffffffc0014741:	48 89 54 24 20       	mov    QWORD PTR [rsp+0x20],rdx
ffffffffc0014746:	4c 89 44 24 30       	mov    QWORD PTR [rsp+0x30],r8
ffffffffc001474b:	40 84 ff             	test   dil,dil
ffffffffc001474e:	74 16                	je     ffffffffc0014766 <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E+0x36>
ffffffffc0014750:	40 80 ff 01          	cmp    dil,0x1
ffffffffc0014754:	75 20                	jne    ffffffffc0014776 <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E+0x46>
ffffffffc0014756:	48 c7 44 24 08 97 7e 	mov    QWORD PTR [rsp+0x8],0xffffffffc0017e97
ffffffffc001475d:	01 c0 
ffffffffc001475f:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0014764:	eb 1e                	jmp    ffffffffc0014784 <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E+0x54>
ffffffffc0014766:	48 c7 44 24 08 99 7e 	mov    QWORD PTR [rsp+0x8],0xffffffffc0017e99
ffffffffc001476d:	01 c0 
ffffffffc001476f:	b8 02 00 00 00       	mov    eax,0x2
ffffffffc0014774:	eb 0e                	jmp    ffffffffc0014784 <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E+0x54>
ffffffffc0014776:	b8 07 00 00 00       	mov    eax,0x7
ffffffffc001477b:	48 c7 44 24 08 90 7e 	mov    QWORD PTR [rsp+0x8],0xffffffffc0017e90
ffffffffc0014782:	01 c0 
ffffffffc0014784:	48 8b b4 24 e0 00 00 	mov    rsi,QWORD PTR [rsp+0xe0]
ffffffffc001478b:	00 
ffffffffc001478c:	49 83 39 00          	cmp    QWORD PTR [r9],0x0
ffffffffc0014790:	48 89 44 24 10       	mov    QWORD PTR [rsp+0x10],rax
ffffffffc0014795:	75 78                	jne    ffffffffc001480f <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E+0xdf>
ffffffffc0014797:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc001479c:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc00147a1:	48 8d 54 24 28       	lea    rdx,[rsp+0x28]
ffffffffc00147a6:	48 c7 44 24 78 20 7f 	mov    QWORD PTR [rsp+0x78],0xffffffffc0017f20
ffffffffc00147ad:	01 c0 
ffffffffc00147af:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x4
ffffffffc00147b6:	00 04 00 00 00 
ffffffffc00147bb:	48 c7 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],0x0
ffffffffc00147c2:	00 00 00 00 00 
ffffffffc00147c7:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc00147cc:	48 c7 44 24 40 e0 45 	mov    QWORD PTR [rsp+0x40],0xffffffffc00145e0
ffffffffc00147d3:	01 c0 
ffffffffc00147d5:	48 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],rcx
ffffffffc00147da:	48 8d 4c 24 38       	lea    rcx,[rsp+0x38]
ffffffffc00147df:	48 c7 44 24 50 70 45 	mov    QWORD PTR [rsp+0x50],0xffffffffc0014570
ffffffffc00147e6:	01 c0 
ffffffffc00147e8:	48 89 54 24 58       	mov    QWORD PTR [rsp+0x58],rdx
ffffffffc00147ed:	48 c7 44 24 60 70 45 	mov    QWORD PTR [rsp+0x60],0xffffffffc0014570
ffffffffc00147f4:	01 c0 
ffffffffc00147f6:	48 89 8c 24 98 00 00 	mov    QWORD PTR [rsp+0x98],rcx
ffffffffc00147fd:	00 
ffffffffc00147fe:	48 c7 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],0x3
ffffffffc0014805:	00 03 00 00 00 
ffffffffc001480a:	e9 d0 00 00 00       	jmp    ffffffffc00148df <_ZN4core9panicking19assert_failed_inner17he2f1f4774d27a4c8E+0x1af>
ffffffffc001480f:	49 8b 49 20          	mov    rcx,QWORD PTR [r9+0x20]
ffffffffc0014813:	49 8b 51 18          	mov    rdx,QWORD PTR [r9+0x18]
ffffffffc0014817:	49 8b 41 28          	mov    rax,QWORD PTR [r9+0x28]
ffffffffc001481b:	48 c7 44 24 78 d8 7e 	mov    QWORD PTR [rsp+0x78],0xffffffffc0017ed8
ffffffffc0014822:	01 c0 
ffffffffc0014824:	48 c7 84 24 80 00 00 	mov    QWORD PTR [rsp+0x80],0x4
ffffffffc001482b:	00 04 00 00 00 
ffffffffc0014830:	48 c7 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],0x0
ffffffffc0014837:	00 00 00 00 00 
ffffffffc001483c:	48 89 8c 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rcx
ffffffffc0014843:	00 
ffffffffc0014844:	49 8b 49 10          	mov    rcx,QWORD PTR [r9+0x10]
ffffffffc0014848:	48 89 94 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdx
ffffffffc001484f:	00 
ffffffffc0014850:	49 8b 11             	mov    rdx,QWORD PTR [r9]
ffffffffc0014853:	48 89 84 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rax
ffffffffc001485a:	00 
ffffffffc001485b:	48 89 8c 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rcx
ffffffffc0014862:	00 
ffffffffc0014863:	49 8b 49 08          	mov    rcx,QWORD PTR [r9+0x8]
ffffffffc0014867:	48 89 94 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rdx
ffffffffc001486e:	00 
ffffffffc001486f:	48 8d 54 24 18       	lea    rdx,[rsp+0x18]
ffffffffc0014874:	48 89 8c 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rcx
ffffffffc001487b:	00 
ffffffffc001487c:	48 8d 4c 24 08       	lea    rcx,[rsp+0x8]
ffffffffc0014881:	48 89 4c 24 38       	mov    QWORD PTR [rsp+0x38],rcx
ffffffffc0014886:	48 8d 4c 24 28       	lea    rcx,[rsp+0x28]
ffffffffc001488b:	48 c7 44 24 40 e0 45 	mov    QWORD PTR [rsp+0x40],0xffffffffc00145e0
ffffffffc0014892:	01 c0 
ffffffffc0014894:	48 89 54 24 48       	mov    QWORD PTR [rsp+0x48],rdx
ffffffffc0014899:	48 c7 44 24 50 70 45 	mov    QWORD PTR [rsp+0x50],0xffffffffc0014570
ffffffffc00148a0:	01 c0 
ffffffffc00148a2:	48 8d 94 24 a8 00 00 	lea    rdx,[rsp+0xa8]
ffffffffc00148a9:	00 
ffffffffc00148aa:	48 89 4c 24 58       	mov    QWORD PTR [rsp+0x58],rcx
ffffffffc00148af:	48 8d 4c 24 38       	lea    rcx,[rsp+0x38]
ffffffffc00148b4:	48 c7 44 24 60 70 45 	mov    QWORD PTR [rsp+0x60],0xffffffffc0014570
ffffffffc00148bb:	01 c0 
ffffffffc00148bd:	48 89 54 24 68       	mov    QWORD PTR [rsp+0x68],rdx
ffffffffc00148c2:	48 c7 44 24 70 a0 32 	mov    QWORD PTR [rsp+0x70],0xffffffffc00132a0
ffffffffc00148c9:	01 c0 
ffffffffc00148cb:	48 89 8c 24 98 00 00 	mov    QWORD PTR [rsp+0x98],rcx
ffffffffc00148d2:	00 
ffffffffc00148d3:	48 c7 84 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],0x4
ffffffffc00148da:	00 04 00 00 00 
ffffffffc00148df:	48 8d 7c 24 78       	lea    rdi,[rsp+0x78]
ffffffffc00148e4:	e8 17 fe ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc00148e9:	0f 0b                	ud2    
ffffffffc00148eb:	cc                   	int3   
ffffffffc00148ec:	cc                   	int3   
ffffffffc00148ed:	cc                   	int3   
ffffffffc00148ee:	cc                   	int3   
ffffffffc00148ef:	cc                   	int3   

ffffffffc00148f0 <_ZN60_$LT$core..alloc..AllocError$u20$as$u20$core..fmt..Debug$GT$3fmt17h41a44513805fcf8fE>:
ffffffffc00148f0:	48 8b 46 28          	mov    rax,QWORD PTR [rsi+0x28]
ffffffffc00148f4:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
ffffffffc00148f8:	ba 0a 00 00 00       	mov    edx,0xa
ffffffffc00148fd:	48 c7 c6 60 7f 01 c0 	mov    rsi,0xffffffffc0017f60
ffffffffc0014904:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
ffffffffc0014908:	ff e0                	jmp    rax
ffffffffc001490a:	cc                   	int3   
ffffffffc001490b:	cc                   	int3   
ffffffffc001490c:	cc                   	int3   
ffffffffc001490d:	cc                   	int3   
ffffffffc001490e:	cc                   	int3   
ffffffffc001490f:	cc                   	int3   

ffffffffc0014910 <_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h5ac0207de2d3856dE>:
ffffffffc0014910:	48 b8 b3 ed 5d 94 60 	movabs rax,0xdb025660945dedb3
ffffffffc0014917:	56 02 db 
ffffffffc001491a:	c3                   	ret    
ffffffffc001491b:	cc                   	int3   
ffffffffc001491c:	cc                   	int3   
ffffffffc001491d:	cc                   	int3   
ffffffffc001491e:	cc                   	int3   
ffffffffc001491f:	cc                   	int3   

ffffffffc0014920 <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E>:
ffffffffc0014920:	55                   	push   rbp
ffffffffc0014921:	41 57                	push   r15
ffffffffc0014923:	41 56                	push   r14
ffffffffc0014925:	41 55                	push   r13
ffffffffc0014927:	41 54                	push   r12
ffffffffc0014929:	53                   	push   rbx
ffffffffc001492a:	48 83 ec 68          	sub    rsp,0x68
ffffffffc001492e:	4c 8b 66 20          	mov    r12,QWORD PTR [rsi+0x20]
ffffffffc0014932:	4c 8b 76 28          	mov    r14,QWORD PTR [rsi+0x28]
ffffffffc0014936:	49 89 ff             	mov    r15,rdi
ffffffffc0014939:	ba 0c 00 00 00       	mov    edx,0xc
ffffffffc001493e:	48 c7 c6 30 80 01 c0 	mov    rsi,0xffffffffc0018030
ffffffffc0014945:	4c 89 e7             	mov    rdi,r12
ffffffffc0014948:	41 ff 56 18          	call   QWORD PTR [r14+0x18]
ffffffffc001494c:	b3 01                	mov    bl,0x1
ffffffffc001494e:	84 c0                	test   al,al
ffffffffc0014950:	0f 85 24 01 00 00    	jne    ffffffffc0014a7a <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E+0x15a>
ffffffffc0014956:	49 8b 47 10          	mov    rax,QWORD PTR [r15+0x10]
ffffffffc001495a:	48 85 c0             	test   rax,rax
ffffffffc001495d:	74 17                	je     ffffffffc0014976 <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E+0x56>
ffffffffc001495f:	48 89 e1             	mov    rcx,rsp
ffffffffc0014962:	48 89 04 24          	mov    QWORD PTR [rsp],rax
ffffffffc0014966:	48 89 4c 24 38       	mov    QWORD PTR [rsp+0x38],rcx
ffffffffc001496b:	48 c7 44 24 40 80 45 	mov    QWORD PTR [rsp+0x40],0xffffffffc0014580
ffffffffc0014972:	01 c0 
ffffffffc0014974:	eb 4c                	jmp    ffffffffc00149c2 <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E+0xa2>
ffffffffc0014976:	49 8b 47 08          	mov    rax,QWORD PTR [r15+0x8]
ffffffffc001497a:	4d 8b 2f             	mov    r13,QWORD PTR [r15]
ffffffffc001497d:	48 8b 68 18          	mov    rbp,QWORD PTR [rax+0x18]
ffffffffc0014981:	4c 89 ef             	mov    rdi,r13
ffffffffc0014984:	ff d5                	call   rbp
ffffffffc0014986:	48 b9 0b f2 b9 22 c7 	movabs rcx,0xb8ae3dc722b9f20b
ffffffffc001498d:	3d ae b8 
ffffffffc0014990:	48 39 c8             	cmp    rax,rcx
ffffffffc0014993:	75 6f                	jne    ffffffffc0014a04 <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E+0xe4>
ffffffffc0014995:	4c 89 ef             	mov    rdi,r13
ffffffffc0014998:	ff d5                	call   rbp
ffffffffc001499a:	48 b9 0b f2 b9 22 c7 	movabs rcx,0xb8ae3dc722b9f20b
ffffffffc00149a1:	3d ae b8 
ffffffffc00149a4:	48 39 c8             	cmp    rax,rcx
ffffffffc00149a7:	0f 85 de 00 00 00    	jne    ffffffffc0014a8b <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E+0x16b>
ffffffffc00149ad:	48 89 e0             	mov    rax,rsp
ffffffffc00149b0:	4c 89 2c 24          	mov    QWORD PTR [rsp],r13
ffffffffc00149b4:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc00149b9:	48 c7 44 24 40 00 46 	mov    QWORD PTR [rsp+0x40],0xffffffffc0014600
ffffffffc00149c0:	01 c0 
ffffffffc00149c2:	48 8d 44 24 38       	lea    rax,[rsp+0x38]
ffffffffc00149c7:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc00149cc:	4c 89 e7             	mov    rdi,r12
ffffffffc00149cf:	4c 89 f6             	mov    rsi,r14
ffffffffc00149d2:	48 c7 44 24 08 40 80 	mov    QWORD PTR [rsp+0x8],0xffffffffc0018040
ffffffffc00149d9:	01 c0 
ffffffffc00149db:	48 c7 44 24 10 02 00 	mov    QWORD PTR [rsp+0x10],0x2
ffffffffc00149e2:	00 00 
ffffffffc00149e4:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc00149eb:	00 00 
ffffffffc00149ed:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
ffffffffc00149f2:	48 c7 44 24 30 01 00 	mov    QWORD PTR [rsp+0x30],0x1
ffffffffc00149f9:	00 00 
ffffffffc00149fb:	e8 00 e9 ff ff       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0014a00:	84 c0                	test   al,al
ffffffffc0014a02:	75 76                	jne    ffffffffc0014a7a <_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h8d2cb35d096ade03E+0x15a>
ffffffffc0014a04:	49 8b 47 18          	mov    rax,QWORD PTR [r15+0x18]
ffffffffc0014a08:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc0014a0d:	4c 89 e7             	mov    rdi,r12
ffffffffc0014a10:	4c 89 f6             	mov    rsi,r14
ffffffffc0014a13:	48 c7 44 24 08 78 7f 	mov    QWORD PTR [rsp+0x8],0xffffffffc0017f78
ffffffffc0014a1a:	01 c0 
ffffffffc0014a1c:	48 c7 44 24 10 03 00 	mov    QWORD PTR [rsp+0x10],0x3
ffffffffc0014a23:	00 00 
ffffffffc0014a25:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0014a2c:	00 00 
ffffffffc0014a2e:	48 89 44 24 38       	mov    QWORD PTR [rsp+0x38],rax
ffffffffc0014a33:	48 8d 48 10          	lea    rcx,[rax+0x10]
ffffffffc0014a37:	48 83 c0 14          	add    rax,0x14
ffffffffc0014a3b:	48 c7 44 24 40 e0 45 	mov    QWORD PTR [rsp+0x40],0xffffffffc00145e0
ffffffffc0014a42:	01 c0 
ffffffffc0014a44:	48 89 4c 24 48       	mov    QWORD PTR [rsp+0x48],rcx
ffffffffc0014a49:	48 c7 44 24 50 00 54 	mov    QWORD PTR [rsp+0x50],0xffffffffc0015400
ffffffffc0014a50:	01 c0 
ffffffffc0014a52:	48 89 44 24 58       	mov    QWORD PTR [rsp+0x58],rax
ffffffffc0014a57:	48 8d 44 24 38       	lea    rax,[rsp+0x38]
ffffffffc0014a5c:	48 c7 44 24 60 00 54 	mov    QWORD PTR [rsp+0x60],0xffffffffc0015400
ffffffffc0014a63:	01 c0 
ffffffffc0014a65:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
ffffffffc0014a6a:	48 c7 44 24 30 03 00 	mov    QWORD PTR [rsp+0x30],0x3
ffffffffc0014a71:	00 00 
ffffffffc0014a73:	e8 88 e8 ff ff       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc0014a78:	89 c3                	mov    ebx,eax
ffffffffc0014a7a:	89 d8                	mov    eax,ebx
ffffffffc0014a7c:	48 83 c4 68          	add    rsp,0x68
ffffffffc0014a80:	5b                   	pop    rbx
ffffffffc0014a81:	41 5c                	pop    r12
ffffffffc0014a83:	41 5d                	pop    r13
ffffffffc0014a85:	41 5e                	pop    r14
ffffffffc0014a87:	41 5f                	pop    r15
ffffffffc0014a89:	5d                   	pop    rbp
ffffffffc0014a8a:	c3                   	ret    
ffffffffc0014a8b:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0014a90:	48 c7 c7 d0 6c 01 c0 	mov    rdi,0xffffffffc0016cd0
ffffffffc0014a97:	48 c7 c2 18 80 01 c0 	mov    rdx,0xffffffffc0018018
ffffffffc0014a9e:	e8 8d fb ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014aa3:	0f 0b                	ud2    
ffffffffc0014aa5:	cc                   	int3   
ffffffffc0014aa6:	cc                   	int3   
ffffffffc0014aa7:	cc                   	int3   
ffffffffc0014aa8:	cc                   	int3   
ffffffffc0014aa9:	cc                   	int3   
ffffffffc0014aaa:	cc                   	int3   
ffffffffc0014aab:	cc                   	int3   
ffffffffc0014aac:	cc                   	int3   
ffffffffc0014aad:	cc                   	int3   
ffffffffc0014aae:	cc                   	int3   
ffffffffc0014aaf:	cc                   	int3   

ffffffffc0014ab0 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E>:
ffffffffc0014ab0:	41 57                	push   r15
ffffffffc0014ab2:	41 56                	push   r14
ffffffffc0014ab4:	41 55                	push   r13
ffffffffc0014ab6:	41 54                	push   r12
ffffffffc0014ab8:	53                   	push   rbx
ffffffffc0014ab9:	4c 8d 47 07          	lea    r8,[rdi+0x7]
ffffffffc0014abd:	49 83 e0 f8          	and    r8,0xfffffffffffffff8
ffffffffc0014ac1:	49 29 f8             	sub    r8,rdi
ffffffffc0014ac4:	49 39 f0             	cmp    r8,rsi
ffffffffc0014ac7:	76 36                	jbe    ffffffffc0014aff <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x4f>
ffffffffc0014ac9:	48 85 f6             	test   rsi,rsi
ffffffffc0014acc:	0f 84 cf 02 00 00    	je     ffffffffc0014da1 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x2f1>
ffffffffc0014ad2:	31 c9                	xor    ecx,ecx
ffffffffc0014ad4:	31 c0                	xor    eax,eax
ffffffffc0014ad6:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014add:	00 00 00 
ffffffffc0014ae0:	31 d2                	xor    edx,edx
ffffffffc0014ae2:	80 3c 0f c0          	cmp    BYTE PTR [rdi+rcx*1],0xc0
ffffffffc0014ae6:	0f 9d c2             	setge  dl
ffffffffc0014ae9:	48 01 d0             	add    rax,rdx
ffffffffc0014aec:	0f 82 05 03 00 00    	jb     ffffffffc0014df7 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x347>
ffffffffc0014af2:	48 ff c1             	inc    rcx
ffffffffc0014af5:	48 39 ce             	cmp    rsi,rcx
ffffffffc0014af8:	75 e6                	jne    ffffffffc0014ae0 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x30>
ffffffffc0014afa:	e9 a4 02 00 00       	jmp    ffffffffc0014da3 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x2f3>
ffffffffc0014aff:	4e 8d 14 07          	lea    r10,[rdi+r8*1]
ffffffffc0014b03:	41 f6 c2 07          	test   r10b,0x7
ffffffffc0014b07:	0f 85 6c 03 00 00    	jne    ffffffffc0014e79 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x3c9>
ffffffffc0014b0d:	49 89 f6             	mov    r14,rsi
ffffffffc0014b10:	4d 29 c6             	sub    r14,r8
ffffffffc0014b13:	0f 88 60 03 00 00    	js     ffffffffc0014e79 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x3c9>
ffffffffc0014b19:	44 89 f1             	mov    ecx,r14d
ffffffffc0014b1c:	83 e1 07             	and    ecx,0x7
ffffffffc0014b1f:	49 39 ce             	cmp    r14,rcx
ffffffffc0014b22:	0f 82 37 03 00 00    	jb     ffffffffc0014e5f <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x3af>
ffffffffc0014b28:	49 83 f8 08          	cmp    r8,0x8
ffffffffc0014b2c:	77 9b                	ja     ffffffffc0014ac9 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x19>
ffffffffc0014b2e:	49 83 fe 08          	cmp    r14,0x8
ffffffffc0014b32:	72 95                	jb     ffffffffc0014ac9 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x19>
ffffffffc0014b34:	4d 85 c0             	test   r8,r8
ffffffffc0014b37:	0f 84 70 02 00 00    	je     ffffffffc0014dad <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x2fd>
ffffffffc0014b3d:	31 db                	xor    ebx,ebx
ffffffffc0014b3f:	31 c0                	xor    eax,eax
ffffffffc0014b41:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014b48:	0f 1f 84 00 00 00 00 
ffffffffc0014b4f:	00 
ffffffffc0014b50:	31 d2                	xor    edx,edx
ffffffffc0014b52:	80 3c 1f c0          	cmp    BYTE PTR [rdi+rbx*1],0xc0
ffffffffc0014b56:	0f 9d c2             	setge  dl
ffffffffc0014b59:	48 01 d0             	add    rax,rdx
ffffffffc0014b5c:	0f 82 95 02 00 00    	jb     ffffffffc0014df7 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x347>
ffffffffc0014b62:	48 ff c3             	inc    rbx
ffffffffc0014b65:	49 39 d8             	cmp    r8,rbx
ffffffffc0014b68:	75 e6                	jne    ffffffffc0014b50 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0xa0>
ffffffffc0014b6a:	48 85 c9             	test   rcx,rcx
ffffffffc0014b6d:	0f 84 45 02 00 00    	je     ffffffffc0014db8 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x308>
ffffffffc0014b73:	48 f7 d9             	neg    rcx
ffffffffc0014b76:	48 01 f7             	add    rdi,rsi
ffffffffc0014b79:	31 d2                	xor    edx,edx
ffffffffc0014b7b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0014b80:	31 f6                	xor    esi,esi
ffffffffc0014b82:	80 3c 0f c0          	cmp    BYTE PTR [rdi+rcx*1],0xc0
ffffffffc0014b86:	40 0f 9d c6          	setge  sil
ffffffffc0014b8a:	48 01 f2             	add    rdx,rsi
ffffffffc0014b8d:	0f 82 64 02 00 00    	jb     ffffffffc0014df7 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x347>
ffffffffc0014b93:	48 ff c1             	inc    rcx
ffffffffc0014b96:	75 e8                	jne    ffffffffc0014b80 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0xd0>
ffffffffc0014b98:	48 01 d0             	add    rax,rdx
ffffffffc0014b9b:	0f 82 22 02 00 00    	jb     ffffffffc0014dc3 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x313>
ffffffffc0014ba1:	49 c1 ee 03          	shr    r14,0x3
ffffffffc0014ba5:	49 bd 01 01 01 01 01 	movabs r13,0x101010101010101
ffffffffc0014bac:	01 01 01 
ffffffffc0014baf:	49 b9 ff 00 ff 00 ff 	movabs r9,0xff00ff00ff00ff
ffffffffc0014bb6:	00 ff 00 
ffffffffc0014bb9:	49 b8 01 00 01 00 01 	movabs r8,0x1000100010001
ffffffffc0014bc0:	00 01 00 
ffffffffc0014bc3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014bca:	84 00 00 00 00 00 
ffffffffc0014bd0:	4d 85 f6             	test   r14,r14
ffffffffc0014bd3:	0f 84 ca 01 00 00    	je     ffffffffc0014da3 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x2f3>
ffffffffc0014bd9:	4d 89 d3             	mov    r11,r10
ffffffffc0014bdc:	49 81 fe c0 00 00 00 	cmp    r14,0xc0
ffffffffc0014be3:	41 ba c0 00 00 00    	mov    r10d,0xc0
ffffffffc0014be9:	4d 89 f7             	mov    r15,r14
ffffffffc0014bec:	4d 0f 42 d6          	cmovb  r10,r14
ffffffffc0014bf0:	4d 29 d6             	sub    r14,r10
ffffffffc0014bf3:	0f 82 18 02 00 00    	jb     ffffffffc0014e11 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x361>
ffffffffc0014bf9:	44 89 d1             	mov    ecx,r10d
ffffffffc0014bfc:	4d 89 d4             	mov    r12,r10
ffffffffc0014bff:	81 e1 fc 00 00 00    	and    ecx,0xfc
ffffffffc0014c05:	49 29 cc             	sub    r12,rcx
ffffffffc0014c08:	0f 82 03 02 00 00    	jb     ffffffffc0014e11 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x361>
ffffffffc0014c0e:	41 f6 c3 07          	test   r11b,0x7
ffffffffc0014c12:	0f 85 61 02 00 00    	jne    ffffffffc0014e79 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x3c9>
ffffffffc0014c18:	48 8d 14 cd 00 00 00 	lea    rdx,[rcx*8+0x0]
ffffffffc0014c1f:	00 
ffffffffc0014c20:	48 85 d2             	test   rdx,rdx
ffffffffc0014c23:	0f 84 b7 00 00 00    	je     ffffffffc0014ce0 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x230>
ffffffffc0014c29:	49 8d 0c cb          	lea    rcx,[r11+rcx*8]
ffffffffc0014c2d:	31 f6                	xor    esi,esi
ffffffffc0014c2f:	4c 89 db             	mov    rbx,r11
ffffffffc0014c32:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014c39:	1f 84 00 00 00 00 00 
ffffffffc0014c40:	48 8b 13             	mov    rdx,QWORD PTR [rbx]
ffffffffc0014c43:	48 89 d7             	mov    rdi,rdx
ffffffffc0014c46:	48 c1 ea 06          	shr    rdx,0x6
ffffffffc0014c4a:	48 f7 d7             	not    rdi
ffffffffc0014c4d:	48 c1 ef 07          	shr    rdi,0x7
ffffffffc0014c51:	48 09 fa             	or     rdx,rdi
ffffffffc0014c54:	4c 21 ea             	and    rdx,r13
ffffffffc0014c57:	48 01 f2             	add    rdx,rsi
ffffffffc0014c5a:	0f 82 7d 01 00 00    	jb     ffffffffc0014ddd <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x32d>
ffffffffc0014c60:	48 8b 73 08          	mov    rsi,QWORD PTR [rbx+0x8]
ffffffffc0014c64:	48 89 f7             	mov    rdi,rsi
ffffffffc0014c67:	48 c1 ee 06          	shr    rsi,0x6
ffffffffc0014c6b:	48 f7 d7             	not    rdi
ffffffffc0014c6e:	48 c1 ef 07          	shr    rdi,0x7
ffffffffc0014c72:	48 09 fe             	or     rsi,rdi
ffffffffc0014c75:	4c 21 ee             	and    rsi,r13
ffffffffc0014c78:	48 01 f2             	add    rdx,rsi
ffffffffc0014c7b:	0f 82 5c 01 00 00    	jb     ffffffffc0014ddd <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x32d>
ffffffffc0014c81:	48 8b 73 10          	mov    rsi,QWORD PTR [rbx+0x10]
ffffffffc0014c85:	48 89 f7             	mov    rdi,rsi
ffffffffc0014c88:	48 c1 ee 06          	shr    rsi,0x6
ffffffffc0014c8c:	48 f7 d7             	not    rdi
ffffffffc0014c8f:	48 c1 ef 07          	shr    rdi,0x7
ffffffffc0014c93:	48 09 fe             	or     rsi,rdi
ffffffffc0014c96:	4c 21 ee             	and    rsi,r13
ffffffffc0014c99:	48 01 f2             	add    rdx,rsi
ffffffffc0014c9c:	0f 82 3b 01 00 00    	jb     ffffffffc0014ddd <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x32d>
ffffffffc0014ca2:	48 8b 73 18          	mov    rsi,QWORD PTR [rbx+0x18]
ffffffffc0014ca6:	48 89 f7             	mov    rdi,rsi
ffffffffc0014ca9:	48 c1 ee 06          	shr    rsi,0x6
ffffffffc0014cad:	48 f7 d7             	not    rdi
ffffffffc0014cb0:	48 c1 ef 07          	shr    rdi,0x7
ffffffffc0014cb4:	48 09 fe             	or     rsi,rdi
ffffffffc0014cb7:	4c 21 ee             	and    rsi,r13
ffffffffc0014cba:	48 01 f2             	add    rdx,rsi
ffffffffc0014cbd:	0f 82 1a 01 00 00    	jb     ffffffffc0014ddd <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x32d>
ffffffffc0014cc3:	48 83 c3 20          	add    rbx,0x20
ffffffffc0014cc7:	48 89 d6             	mov    rsi,rdx
ffffffffc0014cca:	48 39 cb             	cmp    rbx,rcx
ffffffffc0014ccd:	0f 85 6d ff ff ff    	jne    ffffffffc0014c40 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x190>
ffffffffc0014cd3:	eb 0d                	jmp    ffffffffc0014ce2 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x232>
ffffffffc0014cd5:	66 66 2e 0f 1f 84 00 	data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014cdc:	00 00 00 00 
ffffffffc0014ce0:	31 d2                	xor    edx,edx
ffffffffc0014ce2:	48 89 d1             	mov    rcx,rdx
ffffffffc0014ce5:	48 c1 ea 08          	shr    rdx,0x8
ffffffffc0014ce9:	4c 21 c9             	and    rcx,r9
ffffffffc0014cec:	4c 21 ca             	and    rdx,r9
ffffffffc0014cef:	48 01 ca             	add    rdx,rcx
ffffffffc0014cf2:	49 0f af d0          	imul   rdx,r8
ffffffffc0014cf6:	48 c1 ea 30          	shr    rdx,0x30
ffffffffc0014cfa:	48 01 d0             	add    rax,rdx
ffffffffc0014cfd:	0f 82 28 01 00 00    	jb     ffffffffc0014e2b <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x37b>
ffffffffc0014d03:	4f 8d 14 d3          	lea    r10,[r11+r10*8]
ffffffffc0014d07:	4d 85 e4             	test   r12,r12
ffffffffc0014d0a:	0f 84 c0 fe ff ff    	je     ffffffffc0014bd0 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x120>
ffffffffc0014d10:	49 81 ff c0 00 00 00 	cmp    r15,0xc0
ffffffffc0014d17:	ba c0 00 00 00       	mov    edx,0xc0
ffffffffc0014d1c:	49 0f 42 d7          	cmovb  rdx,r15
ffffffffc0014d20:	31 c9                	xor    ecx,ecx
ffffffffc0014d22:	48 8d 34 d5 00 00 00 	lea    rsi,[rdx*8+0x0]
ffffffffc0014d29:	00 
ffffffffc0014d2a:	48 c1 ea 02          	shr    rdx,0x2
ffffffffc0014d2e:	48 c1 e2 05          	shl    rdx,0x5
ffffffffc0014d32:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014d39:	1f 84 00 00 00 00 00 
ffffffffc0014d40:	49 8b 3c 13          	mov    rdi,QWORD PTR [r11+rdx*1]
ffffffffc0014d44:	48 89 fb             	mov    rbx,rdi
ffffffffc0014d47:	48 c1 ef 06          	shr    rdi,0x6
ffffffffc0014d4b:	48 f7 d3             	not    rbx
ffffffffc0014d4e:	48 c1 eb 07          	shr    rbx,0x7
ffffffffc0014d52:	48 09 df             	or     rdi,rbx
ffffffffc0014d55:	4c 21 ef             	and    rdi,r13
ffffffffc0014d58:	48 01 f9             	add    rcx,rdi
ffffffffc0014d5b:	0f 82 e4 00 00 00    	jb     ffffffffc0014e45 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x395>
ffffffffc0014d61:	48 83 c2 08          	add    rdx,0x8
ffffffffc0014d65:	48 39 d6             	cmp    rsi,rdx
ffffffffc0014d68:	75 d6                	jne    ffffffffc0014d40 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x290>
ffffffffc0014d6a:	48 89 ca             	mov    rdx,rcx
ffffffffc0014d6d:	48 c1 e9 08          	shr    rcx,0x8
ffffffffc0014d71:	4c 21 ca             	and    rdx,r9
ffffffffc0014d74:	4c 21 c9             	and    rcx,r9
ffffffffc0014d77:	48 01 d1             	add    rcx,rdx
ffffffffc0014d7a:	49 0f af c8          	imul   rcx,r8
ffffffffc0014d7e:	48 c1 e9 30          	shr    rcx,0x30
ffffffffc0014d82:	48 01 c8             	add    rax,rcx
ffffffffc0014d85:	73 1c                	jae    ffffffffc0014da3 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0x2f3>
ffffffffc0014d87:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014d8c:	48 c7 c7 60 80 01 c0 	mov    rdi,0xffffffffc0018060
ffffffffc0014d93:	48 c7 c2 98 82 01 c0 	mov    rdx,0xffffffffc0018298
ffffffffc0014d9a:	e8 91 f8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014d9f:	0f 0b                	ud2    
ffffffffc0014da1:	31 c0                	xor    eax,eax
ffffffffc0014da3:	5b                   	pop    rbx
ffffffffc0014da4:	41 5c                	pop    r12
ffffffffc0014da6:	41 5d                	pop    r13
ffffffffc0014da8:	41 5e                	pop    r14
ffffffffc0014daa:	41 5f                	pop    r15
ffffffffc0014dac:	c3                   	ret    
ffffffffc0014dad:	31 c0                	xor    eax,eax
ffffffffc0014daf:	48 85 c9             	test   rcx,rcx
ffffffffc0014db2:	0f 85 bb fd ff ff    	jne    ffffffffc0014b73 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0xc3>
ffffffffc0014db8:	31 d2                	xor    edx,edx
ffffffffc0014dba:	48 01 d0             	add    rax,rdx
ffffffffc0014dbd:	0f 83 de fd ff ff    	jae    ffffffffc0014ba1 <_ZN4core3str5count14do_count_chars17h4088bffc8fad1671E+0xf1>
ffffffffc0014dc3:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014dc8:	48 c7 c7 60 80 01 c0 	mov    rdi,0xffffffffc0018060
ffffffffc0014dcf:	48 c7 c2 38 82 01 c0 	mov    rdx,0xffffffffc0018238
ffffffffc0014dd6:	e8 55 f8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014ddb:	0f 0b                	ud2    
ffffffffc0014ddd:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014de2:	48 c7 c7 60 80 01 c0 	mov    rdi,0xffffffffc0018060
ffffffffc0014de9:	48 c7 c2 50 82 01 c0 	mov    rdx,0xffffffffc0018250
ffffffffc0014df0:	e8 3b f8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014df5:	0f 0b                	ud2    
ffffffffc0014df7:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014dfc:	48 c7 c7 c0 7c 01 c0 	mov    rdi,0xffffffffc0017cc0
ffffffffc0014e03:	48 c7 c2 20 7e 01 c0 	mov    rdx,0xffffffffc0017e20
ffffffffc0014e0a:	e8 21 f8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014e0f:	0f 0b                	ud2    
ffffffffc0014e11:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0014e16:	48 c7 c7 80 80 01 c0 	mov    rdi,0xffffffffc0018080
ffffffffc0014e1d:	48 c7 c2 18 81 01 c0 	mov    rdx,0xffffffffc0018118
ffffffffc0014e24:	e8 07 f8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014e29:	0f 0b                	ud2    
ffffffffc0014e2b:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014e30:	48 c7 c7 60 80 01 c0 	mov    rdi,0xffffffffc0018060
ffffffffc0014e37:	48 c7 c2 68 82 01 c0 	mov    rdx,0xffffffffc0018268
ffffffffc0014e3e:	e8 ed f7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014e43:	0f 0b                	ud2    
ffffffffc0014e45:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0014e4a:	48 c7 c7 60 80 01 c0 	mov    rdi,0xffffffffc0018060
ffffffffc0014e51:	48 c7 c2 80 82 01 c0 	mov    rdx,0xffffffffc0018280
ffffffffc0014e58:	e8 d3 f7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014e5d:	0f 0b                	ud2    
ffffffffc0014e5f:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0014e64:	48 c7 c7 80 80 01 c0 	mov    rdi,0xffffffffc0018080
ffffffffc0014e6b:	48 c7 c2 a8 81 01 c0 	mov    rdx,0xffffffffc00181a8
ffffffffc0014e72:	e8 b9 f7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0014e77:	0f 0b                	ud2    
ffffffffc0014e79:	0f 0b                	ud2    
ffffffffc0014e7b:	0f 0b                	ud2    
ffffffffc0014e7d:	cc                   	int3   
ffffffffc0014e7e:	cc                   	int3   
ffffffffc0014e7f:	cc                   	int3   

ffffffffc0014e80 <_ZN4core6result13unwrap_failed17he47b8d70f74ecda1E>:
ffffffffc0014e80:	48 83 ec 78          	sub    rsp,0x78
ffffffffc0014e84:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0014e89:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
ffffffffc0014e8e:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc0014e93:	48 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],rcx
ffffffffc0014e98:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc0014e9d:	48 8d 54 24 18       	lea    rdx,[rsp+0x18]
ffffffffc0014ea2:	48 8d 4c 24 28       	lea    rcx,[rsp+0x28]
ffffffffc0014ea7:	48 8d 7c 24 48       	lea    rdi,[rsp+0x48]
ffffffffc0014eac:	4c 89 c6             	mov    rsi,r8
ffffffffc0014eaf:	48 c7 44 24 48 b8 82 	mov    QWORD PTR [rsp+0x48],0xffffffffc00182b8
ffffffffc0014eb6:	01 c0 
ffffffffc0014eb8:	48 c7 44 24 50 02 00 	mov    QWORD PTR [rsp+0x50],0x2
ffffffffc0014ebf:	00 00 
ffffffffc0014ec1:	48 c7 44 24 58 00 00 	mov    QWORD PTR [rsp+0x58],0x0
ffffffffc0014ec8:	00 00 
ffffffffc0014eca:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
ffffffffc0014ecf:	48 c7 44 24 30 e0 45 	mov    QWORD PTR [rsp+0x30],0xffffffffc00145e0
ffffffffc0014ed6:	01 c0 
ffffffffc0014ed8:	48 89 54 24 38       	mov    QWORD PTR [rsp+0x38],rdx
ffffffffc0014edd:	48 89 4c 24 68       	mov    QWORD PTR [rsp+0x68],rcx
ffffffffc0014ee2:	48 c7 44 24 40 70 45 	mov    QWORD PTR [rsp+0x40],0xffffffffc0014570
ffffffffc0014ee9:	01 c0 
ffffffffc0014eeb:	48 c7 44 24 70 02 00 	mov    QWORD PTR [rsp+0x70],0x2
ffffffffc0014ef2:	00 00 
ffffffffc0014ef4:	e8 07 f8 ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0014ef9:	0f 0b                	ud2    
ffffffffc0014efb:	cc                   	int3   
ffffffffc0014efc:	cc                   	int3   
ffffffffc0014efd:	cc                   	int3   
ffffffffc0014efe:	cc                   	int3   
ffffffffc0014eff:	cc                   	int3   

ffffffffc0014f00 <_ZN4core3ops8function6FnOnce9call_once17h06e32c192df6e13dE.llvm.14834836203371451150>:
ffffffffc0014f00:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f04:	e8 27 09 00 00       	call   ffffffffc0015830 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE>
ffffffffc0014f09:	0f 0b                	ud2    
ffffffffc0014f0b:	cc                   	int3   
ffffffffc0014f0c:	cc                   	int3   
ffffffffc0014f0d:	cc                   	int3   
ffffffffc0014f0e:	cc                   	int3   
ffffffffc0014f0f:	cc                   	int3   

ffffffffc0014f10 <_ZN4core3ops8function6FnOnce9call_once17h1ff1e00864bd238eE.llvm.14834836203371451150>:
ffffffffc0014f10:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f14:	e8 97 06 00 00       	call   ffffffffc00155b0 <_ZN4core5slice5index27slice_end_index_len_fail_rt17h63889dc279182820E>
ffffffffc0014f19:	0f 0b                	ud2    
ffffffffc0014f1b:	cc                   	int3   
ffffffffc0014f1c:	cc                   	int3   
ffffffffc0014f1d:	cc                   	int3   
ffffffffc0014f1e:	cc                   	int3   
ffffffffc0014f1f:	cc                   	int3   

ffffffffc0014f20 <_ZN4core3ops8function6FnOnce9call_once17h8aebce5c47317b16E.llvm.14834836203371451150>:
ffffffffc0014f20:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f24:	e8 f7 05 00 00       	call   ffffffffc0015520 <_ZN4core5slice5index29slice_start_index_len_fail_rt17h97395a01743838cdE>
ffffffffc0014f29:	0f 0b                	ud2    
ffffffffc0014f2b:	cc                   	int3   
ffffffffc0014f2c:	cc                   	int3   
ffffffffc0014f2d:	cc                   	int3   
ffffffffc0014f2e:	cc                   	int3   
ffffffffc0014f2f:	cc                   	int3   

ffffffffc0014f30 <_ZN4core3ops8function6FnOnce9call_once17hae7daa18b78cded0E.llvm.14834836203371451150>:
ffffffffc0014f30:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f34:	e8 07 07 00 00       	call   ffffffffc0015640 <_ZN4core5slice5index25slice_index_order_fail_rt17hd7cf48772c620f0eE>
ffffffffc0014f39:	0f 0b                	ud2    
ffffffffc0014f3b:	cc                   	int3   
ffffffffc0014f3c:	cc                   	int3   
ffffffffc0014f3d:	cc                   	int3   
ffffffffc0014f3e:	cc                   	int3   
ffffffffc0014f3f:	cc                   	int3   

ffffffffc0014f40 <_ZN4core10intrinsics17const_eval_select17h47d2d46d4807ad98E>:
ffffffffc0014f40:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f44:	e8 c7 ff ff ff       	call   ffffffffc0014f10 <_ZN4core3ops8function6FnOnce9call_once17h1ff1e00864bd238eE.llvm.14834836203371451150>
ffffffffc0014f49:	0f 0b                	ud2    
ffffffffc0014f4b:	cc                   	int3   
ffffffffc0014f4c:	cc                   	int3   
ffffffffc0014f4d:	cc                   	int3   
ffffffffc0014f4e:	cc                   	int3   
ffffffffc0014f4f:	cc                   	int3   

ffffffffc0014f50 <_ZN4core10intrinsics17const_eval_select17h53979d727fcb3488E>:
ffffffffc0014f50:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f54:	e8 c7 ff ff ff       	call   ffffffffc0014f20 <_ZN4core3ops8function6FnOnce9call_once17h8aebce5c47317b16E.llvm.14834836203371451150>
ffffffffc0014f59:	0f 0b                	ud2    
ffffffffc0014f5b:	cc                   	int3   
ffffffffc0014f5c:	cc                   	int3   
ffffffffc0014f5d:	cc                   	int3   
ffffffffc0014f5e:	cc                   	int3   
ffffffffc0014f5f:	cc                   	int3   

ffffffffc0014f60 <_ZN4core10intrinsics17const_eval_select17h749e253dcc334a1dE>:
ffffffffc0014f60:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f64:	e8 c7 ff ff ff       	call   ffffffffc0014f30 <_ZN4core3ops8function6FnOnce9call_once17hae7daa18b78cded0E.llvm.14834836203371451150>
ffffffffc0014f69:	0f 0b                	ud2    
ffffffffc0014f6b:	cc                   	int3   
ffffffffc0014f6c:	cc                   	int3   
ffffffffc0014f6d:	cc                   	int3   
ffffffffc0014f6e:	cc                   	int3   
ffffffffc0014f6f:	cc                   	int3   

ffffffffc0014f70 <_ZN4core10intrinsics17const_eval_select17h981370acf09ad35dE>:
ffffffffc0014f70:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f74:	48 8b 07             	mov    rax,QWORD PTR [rdi]
ffffffffc0014f77:	48 8b 77 08          	mov    rsi,QWORD PTR [rdi+0x8]
ffffffffc0014f7b:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
ffffffffc0014f7f:	48 8b 4f 18          	mov    rcx,QWORD PTR [rdi+0x18]
ffffffffc0014f83:	48 89 c7             	mov    rdi,rax
ffffffffc0014f86:	e8 75 ff ff ff       	call   ffffffffc0014f00 <_ZN4core3ops8function6FnOnce9call_once17h06e32c192df6e13dE.llvm.14834836203371451150>
ffffffffc0014f8b:	0f 0b                	ud2    
ffffffffc0014f8d:	cc                   	int3   
ffffffffc0014f8e:	cc                   	int3   
ffffffffc0014f8f:	cc                   	int3   

ffffffffc0014f90 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150>:
ffffffffc0014f90:	41 56                	push   r14
ffffffffc0014f92:	53                   	push   rbx
ffffffffc0014f93:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0014f97:	48 85 d2             	test   rdx,rdx
ffffffffc0014f9a:	0f 84 89 00 00 00    	je     ffffffffc0015029 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x99>
ffffffffc0014fa0:	4c 8d 1c 56          	lea    r11,[rsi+rdx*2]
ffffffffc0014fa4:	0f b6 56 01          	movzx  edx,BYTE PTR [rsi+0x1]
ffffffffc0014fa8:	41 89 fa             	mov    r10d,edi
ffffffffc0014fab:	49 89 f6             	mov    r14,rsi
ffffffffc0014fae:	31 db                	xor    ebx,ebx
ffffffffc0014fb0:	41 c1 ea 08          	shr    r10d,0x8
ffffffffc0014fb4:	49 83 c6 02          	add    r14,0x2
ffffffffc0014fb8:	48 89 d0             	mov    rax,rdx
ffffffffc0014fbb:	44 38 16             	cmp    BYTE PTR [rsi],r10b
ffffffffc0014fbe:	75 30                	jne    ffffffffc0014ff0 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x60>
ffffffffc0014fc0:	4c 39 c0             	cmp    rax,r8
ffffffffc0014fc3:	0f 87 fc 00 00 00    	ja     ffffffffc00150c5 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x135>
ffffffffc0014fc9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
ffffffffc0014fd0:	48 39 d8             	cmp    rax,rbx
ffffffffc0014fd3:	74 1d                	je     ffffffffc0014ff2 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x62>
ffffffffc0014fd5:	48 8d 53 01          	lea    rdx,[rbx+0x1]
ffffffffc0014fd9:	40 38 3c 19          	cmp    BYTE PTR [rcx+rbx*1],dil
ffffffffc0014fdd:	48 89 d3             	mov    rbx,rdx
ffffffffc0014fe0:	75 ee                	jne    ffffffffc0014fd0 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x40>
ffffffffc0014fe2:	eb 41                	jmp    ffffffffc0015025 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x95>
ffffffffc0014fe4:	66 66 66 2e 0f 1f 84 	data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0014feb:	00 00 00 00 00 
ffffffffc0014ff0:	77 37                	ja     ffffffffc0015029 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x99>
ffffffffc0014ff2:	4d 39 de             	cmp    r14,r11
ffffffffc0014ff5:	74 32                	je     ffffffffc0015029 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x99>
ffffffffc0014ff7:	41 0f b6 56 01       	movzx  edx,BYTE PTR [r14+0x1]
ffffffffc0014ffc:	4c 89 f6             	mov    rsi,r14
ffffffffc0014fff:	49 83 c6 02          	add    r14,0x2
ffffffffc0015003:	48 89 c3             	mov    rbx,rax
ffffffffc0015006:	48 01 c2             	add    rdx,rax
ffffffffc0015009:	73 ad                	jae    ffffffffc0014fb8 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x28>
ffffffffc001500b:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0015010:	48 c7 c7 10 83 01 c0 	mov    rdi,0xffffffffc0018310
ffffffffc0015017:	48 c7 c2 d8 83 01 c0 	mov    rdx,0xffffffffc00183d8
ffffffffc001501e:	e8 0d f6 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015023:	0f 0b                	ud2    
ffffffffc0015025:	31 c0                	xor    eax,eax
ffffffffc0015027:	eb 5e                	jmp    ffffffffc0015087 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xf7>
ffffffffc0015029:	48 8b 4c 24 20       	mov    rcx,QWORD PTR [rsp+0x20]
ffffffffc001502e:	48 85 c9             	test   rcx,rcx
ffffffffc0015031:	74 52                	je     ffffffffc0015085 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xf5>
ffffffffc0015033:	4c 01 c9             	add    rcx,r9
ffffffffc0015036:	0f b7 d7             	movzx  edx,di
ffffffffc0015039:	b0 01                	mov    al,0x1
ffffffffc001503b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0015040:	41 0f b6 31          	movzx  esi,BYTE PTR [r9]
ffffffffc0015044:	49 8d 79 01          	lea    rdi,[r9+0x1]
ffffffffc0015048:	40 84 f6             	test   sil,sil
ffffffffc001504b:	78 13                	js     ffffffffc0015060 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xd0>
ffffffffc001504d:	49 89 f9             	mov    r9,rdi
ffffffffc0015050:	29 f2                	sub    edx,esi
ffffffffc0015052:	71 26                	jno    ffffffffc001507a <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xea>
ffffffffc0015054:	eb 3b                	jmp    ffffffffc0015091 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x101>
ffffffffc0015056:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc001505d:	00 00 00 
ffffffffc0015060:	48 39 cf             	cmp    rdi,rcx
ffffffffc0015063:	74 46                	je     ffffffffc00150ab <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x11b>
ffffffffc0015065:	41 0f b6 79 01       	movzx  edi,BYTE PTR [r9+0x1]
ffffffffc001506a:	83 e6 7f             	and    esi,0x7f
ffffffffc001506d:	49 83 c1 02          	add    r9,0x2
ffffffffc0015071:	c1 e6 08             	shl    esi,0x8
ffffffffc0015074:	09 fe                	or     esi,edi
ffffffffc0015076:	29 f2                	sub    edx,esi
ffffffffc0015078:	70 17                	jo     ffffffffc0015091 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0x101>
ffffffffc001507a:	78 0b                	js     ffffffffc0015087 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xf7>
ffffffffc001507c:	34 01                	xor    al,0x1
ffffffffc001507e:	49 39 c9             	cmp    r9,rcx
ffffffffc0015081:	75 bd                	jne    ffffffffc0015040 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xb0>
ffffffffc0015083:	eb 02                	jmp    ffffffffc0015087 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150+0xf7>
ffffffffc0015085:	b0 01                	mov    al,0x1
ffffffffc0015087:	24 01                	and    al,0x1
ffffffffc0015089:	48 83 c4 08          	add    rsp,0x8
ffffffffc001508d:	5b                   	pop    rbx
ffffffffc001508e:	41 5e                	pop    r14
ffffffffc0015090:	c3                   	ret    
ffffffffc0015091:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015096:	48 c7 c7 e0 82 01 c0 	mov    rdi,0xffffffffc00182e0
ffffffffc001509d:	48 c7 c2 20 84 01 c0 	mov    rdx,0xffffffffc0018420
ffffffffc00150a4:	e8 87 f5 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00150a9:	0f 0b                	ud2    
ffffffffc00150ab:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc00150b0:	48 c7 c7 2c 83 01 c0 	mov    rdi,0xffffffffc001832c
ffffffffc00150b7:	48 c7 c2 08 84 01 c0 	mov    rdx,0xffffffffc0018408
ffffffffc00150be:	e8 6d f5 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00150c3:	0f 0b                	ud2    
ffffffffc00150c5:	48 89 d7             	mov    rdi,rdx
ffffffffc00150c8:	4c 89 c6             	mov    rsi,r8
ffffffffc00150cb:	48 c7 c2 f0 83 01 c0 	mov    rdx,0xffffffffc00183f0
ffffffffc00150d2:	e8 c9 04 00 00       	call   ffffffffc00155a0 <_ZN4core5slice5index24slice_end_index_len_fail17hdc06d5317026ab27E>
ffffffffc00150d7:	0f 0b                	ud2    
ffffffffc00150d9:	cc                   	int3   
ffffffffc00150da:	cc                   	int3   
ffffffffc00150db:	cc                   	int3   
ffffffffc00150dc:	cc                   	int3   
ffffffffc00150dd:	cc                   	int3   
ffffffffc00150de:	cc                   	int3   
ffffffffc00150df:	cc                   	int3   

ffffffffc00150e0 <_ZN4core7unicode9printable12is_printable17hd24752249c0f9d67E>:
ffffffffc00150e0:	48 83 ec 08          	sub    rsp,0x8
ffffffffc00150e4:	81 ff 00 00 01 00    	cmp    edi,0x10000
ffffffffc00150ea:	73 2a                	jae    ffffffffc0015116 <_ZN4core7unicode9printable12is_printable17hd24752249c0f9d67E+0x36>
ffffffffc00150ec:	ba 28 00 00 00       	mov    edx,0x28
ffffffffc00150f1:	41 b8 20 01 00 00    	mov    r8d,0x120
ffffffffc00150f7:	48 c7 c6 38 84 01 c0 	mov    rsi,0xffffffffc0018438
ffffffffc00150fe:	48 c7 c1 88 84 01 c0 	mov    rcx,0xffffffffc0018488
ffffffffc0015105:	49 c7 c1 a8 85 01 c0 	mov    r9,0xffffffffc00185a8
ffffffffc001510c:	48 c7 04 24 2f 01 00 	mov    QWORD PTR [rsp],0x12f
ffffffffc0015113:	00 
ffffffffc0015114:	eb 30                	jmp    ffffffffc0015146 <_ZN4core7unicode9printable12is_printable17hd24752249c0f9d67E+0x66>
ffffffffc0015116:	81 ff 00 00 02 00    	cmp    edi,0x20000
ffffffffc001511c:	73 2f                	jae    ffffffffc001514d <_ZN4core7unicode9printable12is_printable17hd24752249c0f9d67E+0x6d>
ffffffffc001511e:	48 c7 04 24 b6 01 00 	mov    QWORD PTR [rsp],0x1b6
ffffffffc0015125:	00 
ffffffffc0015126:	ba 2a 00 00 00       	mov    edx,0x2a
ffffffffc001512b:	41 b8 c0 00 00 00    	mov    r8d,0xc0
ffffffffc0015131:	48 c7 c6 d7 86 01 c0 	mov    rsi,0xffffffffc00186d7
ffffffffc0015138:	48 c7 c1 2b 87 01 c0 	mov    rcx,0xffffffffc001872b
ffffffffc001513f:	49 c7 c1 eb 87 01 c0 	mov    r9,0xffffffffc00187eb
ffffffffc0015146:	e8 45 fe ff ff       	call   ffffffffc0014f90 <_ZN4core7unicode9printable5check17he5dbac6dfd2f6d09E.llvm.14834836203371451150>
ffffffffc001514b:	59                   	pop    rcx
ffffffffc001514c:	c3                   	ret    
ffffffffc001514d:	89 f8                	mov    eax,edi
ffffffffc001514f:	8d 8f c7 48 fd ff    	lea    ecx,[rdi-0x2b739]
ffffffffc0015155:	8d 97 50 31 fd ff    	lea    edx,[rdi-0x2ceb0]
ffffffffc001515b:	25 e0 ff 1f 00       	and    eax,0x1fffe0
ffffffffc0015160:	3d e0 a6 02 00       	cmp    eax,0x2a6e0
ffffffffc0015165:	0f 95 c0             	setne  al
ffffffffc0015168:	83 f9 07             	cmp    ecx,0x7
ffffffffc001516b:	0f 93 c1             	setae  cl
ffffffffc001516e:	20 c1                	and    cl,al
ffffffffc0015170:	89 f8                	mov    eax,edi
ffffffffc0015172:	25 fe ff 1f 00       	and    eax,0x1ffffe
ffffffffc0015177:	3d 1e b8 02 00       	cmp    eax,0x2b81e
ffffffffc001517c:	0f 95 c0             	setne  al
ffffffffc001517f:	83 fa f2             	cmp    edx,0xfffffff2
ffffffffc0015182:	0f 92 c2             	setb   dl
ffffffffc0015185:	20 c2                	and    dl,al
ffffffffc0015187:	8d 87 00 08 fd ff    	lea    eax,[rdi-0x2f800]
ffffffffc001518d:	20 ca                	and    dl,cl
ffffffffc001518f:	3d e1 f3 ff ff       	cmp    eax,0xfffff3e1
ffffffffc0015194:	8d 8f 00 00 fd ff    	lea    ecx,[rdi-0x30000]
ffffffffc001519a:	0f 92 c0             	setb   al
ffffffffc001519d:	81 f9 1e fa ff ff    	cmp    ecx,0xfffffa1e
ffffffffc00151a3:	40 0f 92 c6          	setb   sil
ffffffffc00151a7:	40 20 c6             	and    sil,al
ffffffffc00151aa:	8d 87 00 ff f1 ff    	lea    eax,[rdi-0xe0100]
ffffffffc00151b0:	3d 4b 12 f5 ff       	cmp    eax,0xfff5124b
ffffffffc00151b5:	0f 92 c1             	setb   cl
ffffffffc00151b8:	40 20 f1             	and    cl,sil
ffffffffc00151bb:	20 d1                	and    cl,dl
ffffffffc00151bd:	81 ff f0 01 0e 00    	cmp    edi,0xe01f0
ffffffffc00151c3:	0f 92 c0             	setb   al
ffffffffc00151c6:	20 c8                	and    al,cl
ffffffffc00151c8:	59                   	pop    rcx
ffffffffc00151c9:	c3                   	ret    
ffffffffc00151ca:	cc                   	int3   
ffffffffc00151cb:	cc                   	int3   
ffffffffc00151cc:	cc                   	int3   
ffffffffc00151cd:	cc                   	int3   
ffffffffc00151ce:	cc                   	int3   
ffffffffc00151cf:	cc                   	int3   

ffffffffc00151d0 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150>:
ffffffffc00151d0:	41 57                	push   r15
ffffffffc00151d2:	41 56                	push   r14
ffffffffc00151d4:	53                   	push   rbx
ffffffffc00151d5:	48 83 ec 30          	sub    rsp,0x30
ffffffffc00151d9:	49 89 d2             	mov    r10,rdx
ffffffffc00151dc:	48 89 fa             	mov    rdx,rdi
ffffffffc00151df:	41 bb 27 00 00 00    	mov    r11d,0x27
ffffffffc00151e5:	48 81 ff 10 27 00 00 	cmp    rdi,0x2710
ffffffffc00151ec:	0f 82 02 01 00 00    	jb     ffffffffc00152f4 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x124>
ffffffffc00151f2:	41 bb 27 00 00 00    	mov    r11d,0x27
ffffffffc00151f8:	49 b8 4b 59 86 38 d6 	movabs r8,0x346dc5d63886594b
ffffffffc00151ff:	c5 6d 34 
ffffffffc0015202:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 nop WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0015209:	1f 84 00 00 00 00 00 
ffffffffc0015210:	c4 42 b3 f6 c8       	mulx   r9,r9,r8
ffffffffc0015215:	49 83 c3 fc          	add    r11,0xfffffffffffffffc
ffffffffc0015219:	0f 80 a6 01 00 00    	jo     ffffffffc00153c5 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x1f5>
ffffffffc001521f:	49 c1 e9 0b          	shr    r9,0xb
ffffffffc0015223:	48 89 d0             	mov    rax,rdx
ffffffffc0015226:	4e 8d 74 1c 09       	lea    r14,[rsp+r11*1+0x9]
ffffffffc001522b:	49 69 c9 10 27 00 00 	imul   rcx,r9,0x2710
ffffffffc0015232:	48 29 c8             	sub    rax,rcx
ffffffffc0015235:	0f b7 c8             	movzx  ecx,ax
ffffffffc0015238:	c1 e9 02             	shr    ecx,0x2
ffffffffc001523b:	69 c9 7b 14 00 00    	imul   ecx,ecx,0x147b
ffffffffc0015241:	c1 e9 11             	shr    ecx,0x11
ffffffffc0015244:	4c 8d bc 09 02 74 01 	lea    r15,[rcx+rcx*1-0x3ffe8bfe]
ffffffffc001524b:	c0 
ffffffffc001524c:	4c 89 ff             	mov    rdi,r15
ffffffffc001524f:	4c 89 fb             	mov    rbx,r15
ffffffffc0015252:	4c 29 f7             	sub    rdi,r14
ffffffffc0015255:	48 f7 df             	neg    rdi
ffffffffc0015258:	4c 29 f3             	sub    rbx,r14
ffffffffc001525b:	48 0f 46 df          	cmovbe rbx,rdi
ffffffffc001525f:	48 83 fb 01          	cmp    rbx,0x1
ffffffffc0015263:	0f 86 84 01 00 00    	jbe    ffffffffc00153ed <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x21d>
ffffffffc0015269:	41 0f b7 3f          	movzx  edi,WORD PTR [r15]
ffffffffc001526d:	66 42 89 7c 1c 09    	mov    WORD PTR [rsp+r11*1+0x9],di
ffffffffc0015273:	4c 89 df             	mov    rdi,r11
ffffffffc0015276:	48 83 c7 02          	add    rdi,0x2
ffffffffc001527a:	0f 80 53 01 00 00    	jo     ffffffffc00153d3 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x203>
ffffffffc0015280:	6b c9 64             	imul   ecx,ecx,0x64
ffffffffc0015283:	29 c8                	sub    eax,ecx
ffffffffc0015285:	48 8d 4c 3c 09       	lea    rcx,[rsp+rdi*1+0x9]
ffffffffc001528a:	0f b7 c0             	movzx  eax,ax
ffffffffc001528d:	25 ff 7f 00 00       	and    eax,0x7fff
ffffffffc0015292:	48 8d 84 00 02 74 01 	lea    rax,[rax+rax*1-0x3ffe8bfe]
ffffffffc0015299:	c0 
ffffffffc001529a:	48 89 c7             	mov    rdi,rax
ffffffffc001529d:	48 89 c3             	mov    rbx,rax
ffffffffc00152a0:	48 29 cf             	sub    rdi,rcx
ffffffffc00152a3:	48 f7 df             	neg    rdi
ffffffffc00152a6:	48 29 cb             	sub    rbx,rcx
ffffffffc00152a9:	48 0f 46 df          	cmovbe rbx,rdi
ffffffffc00152ad:	48 83 fb 01          	cmp    rbx,0x1
ffffffffc00152b1:	0f 86 36 01 00 00    	jbe    ffffffffc00153ed <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x21d>
ffffffffc00152b7:	0f b7 00             	movzx  eax,WORD PTR [rax]
ffffffffc00152ba:	66 89 01             	mov    WORD PTR [rcx],ax
ffffffffc00152bd:	48 81 fa ff e0 f5 05 	cmp    rdx,0x5f5e0ff
ffffffffc00152c4:	4c 89 ca             	mov    rdx,r9
ffffffffc00152c7:	0f 87 43 ff ff ff    	ja     ffffffffc0015210 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x40>
ffffffffc00152cd:	49 83 f9 63          	cmp    r9,0x63
ffffffffc00152d1:	77 2a                	ja     ffffffffc00152fd <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x12d>
ffffffffc00152d3:	49 83 f9 0a          	cmp    r9,0xa
ffffffffc00152d7:	0f 83 85 00 00 00    	jae    ffffffffc0015362 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x192>
ffffffffc00152dd:	49 ff cb             	dec    r11
ffffffffc00152e0:	0f 80 df 00 00 00    	jo     ffffffffc00153c5 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x1f5>
ffffffffc00152e6:	41 80 c1 30          	add    r9b,0x30
ffffffffc00152ea:	46 88 4c 1c 09       	mov    BYTE PTR [rsp+r11*1+0x9],r9b
ffffffffc00152ef:	e9 a0 00 00 00       	jmp    ffffffffc0015394 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x1c4>
ffffffffc00152f4:	49 89 d1             	mov    r9,rdx
ffffffffc00152f7:	49 83 f9 63          	cmp    r9,0x63
ffffffffc00152fb:	76 d6                	jbe    ffffffffc00152d3 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x103>
ffffffffc00152fd:	49 83 c3 fe          	add    r11,0xfffffffffffffffe
ffffffffc0015301:	0f 80 be 00 00 00    	jo     ffffffffc00153c5 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x1f5>
ffffffffc0015307:	41 0f b7 c1          	movzx  eax,r9w
ffffffffc001530b:	4a 8d 54 1c 09       	lea    rdx,[rsp+r11*1+0x9]
ffffffffc0015310:	c1 e8 02             	shr    eax,0x2
ffffffffc0015313:	69 c0 7b 14 00 00    	imul   eax,eax,0x147b
ffffffffc0015319:	c1 e8 11             	shr    eax,0x11
ffffffffc001531c:	6b c8 64             	imul   ecx,eax,0x64
ffffffffc001531f:	41 29 c9             	sub    r9d,ecx
ffffffffc0015322:	41 81 e1 ff 7f 00 00 	and    r9d,0x7fff
ffffffffc0015329:	4b 8d 9c 09 02 74 01 	lea    rbx,[r9+r9*1-0x3ffe8bfe]
ffffffffc0015330:	c0 
ffffffffc0015331:	48 89 df             	mov    rdi,rbx
ffffffffc0015334:	48 89 d9             	mov    rcx,rbx
ffffffffc0015337:	48 29 d7             	sub    rdi,rdx
ffffffffc001533a:	48 f7 df             	neg    rdi
ffffffffc001533d:	48 29 d1             	sub    rcx,rdx
ffffffffc0015340:	48 0f 46 cf          	cmovbe rcx,rdi
ffffffffc0015344:	48 83 f9 01          	cmp    rcx,0x1
ffffffffc0015348:	0f 86 9f 00 00 00    	jbe    ffffffffc00153ed <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x21d>
ffffffffc001534e:	0f b7 0b             	movzx  ecx,WORD PTR [rbx]
ffffffffc0015351:	44 0f b7 c8          	movzx  r9d,ax
ffffffffc0015355:	66 89 0a             	mov    WORD PTR [rdx],cx
ffffffffc0015358:	49 83 f9 0a          	cmp    r9,0xa
ffffffffc001535c:	0f 82 7b ff ff ff    	jb     ffffffffc00152dd <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x10d>
ffffffffc0015362:	49 83 c3 fe          	add    r11,0xfffffffffffffffe
ffffffffc0015366:	70 5d                	jo     ffffffffc00153c5 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x1f5>
ffffffffc0015368:	4b 8d 84 09 02 74 01 	lea    rax,[r9+r9*1-0x3ffe8bfe]
ffffffffc001536f:	c0 
ffffffffc0015370:	4a 8d 4c 1c 09       	lea    rcx,[rsp+r11*1+0x9]
ffffffffc0015375:	48 89 c2             	mov    rdx,rax
ffffffffc0015378:	48 89 c7             	mov    rdi,rax
ffffffffc001537b:	48 29 ca             	sub    rdx,rcx
ffffffffc001537e:	48 f7 da             	neg    rdx
ffffffffc0015381:	48 29 cf             	sub    rdi,rcx
ffffffffc0015384:	48 0f 46 fa          	cmovbe rdi,rdx
ffffffffc0015388:	48 83 ff 01          	cmp    rdi,0x1
ffffffffc001538c:	76 5f                	jbe    ffffffffc00153ed <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x21d>
ffffffffc001538e:	0f b7 00             	movzx  eax,WORD PTR [rax]
ffffffffc0015391:	66 89 01             	mov    WORD PTR [rcx],ax
ffffffffc0015394:	41 b9 27 00 00 00    	mov    r9d,0x27
ffffffffc001539a:	4d 29 d9             	sub    r9,r11
ffffffffc001539d:	72 26                	jb     ffffffffc00153c5 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x1f5>
ffffffffc001539f:	78 4c                	js     ffffffffc00153ed <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x21d>
ffffffffc00153a1:	4e 8d 44 1c 09       	lea    r8,[rsp+r11*1+0x9]
ffffffffc00153a6:	40 0f b6 f6          	movzx  esi,sil
ffffffffc00153aa:	4c 89 d7             	mov    rdi,r10
ffffffffc00153ad:	48 c7 c2 30 8a 01 c0 	mov    rdx,0xffffffffc0018a30
ffffffffc00153b4:	31 c9                	xor    ecx,ecx
ffffffffc00153b6:	e8 d5 e1 ff ff       	call   ffffffffc0013590 <_ZN4core3fmt9Formatter12pad_integral17h023375bb7f338c81E>
ffffffffc00153bb:	48 83 c4 30          	add    rsp,0x30
ffffffffc00153bf:	5b                   	pop    rbx
ffffffffc00153c0:	41 5e                	pop    r14
ffffffffc00153c2:	41 5f                	pop    r15
ffffffffc00153c4:	c3                   	ret    
ffffffffc00153c5:	be 21 00 00 00       	mov    esi,0x21
ffffffffc00153ca:	48 c7 c7 e0 82 01 c0 	mov    rdi,0xffffffffc00182e0
ffffffffc00153d1:	eb 0c                	jmp    ffffffffc00153df <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150+0x20f>
ffffffffc00153d3:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc00153d8:	48 c7 c7 10 83 01 c0 	mov    rdi,0xffffffffc0018310
ffffffffc00153df:	48 c7 c2 18 8a 01 c0 	mov    rdx,0xffffffffc0018a18
ffffffffc00153e6:	e8 45 f2 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00153eb:	0f 0b                	ud2    
ffffffffc00153ed:	0f 0b                	ud2    
ffffffffc00153ef:	0f 0b                	ud2    
ffffffffc00153f1:	cc                   	int3   
ffffffffc00153f2:	cc                   	int3   
ffffffffc00153f3:	cc                   	int3   
ffffffffc00153f4:	cc                   	int3   
ffffffffc00153f5:	cc                   	int3   
ffffffffc00153f6:	cc                   	int3   
ffffffffc00153f7:	cc                   	int3   
ffffffffc00153f8:	cc                   	int3   
ffffffffc00153f9:	cc                   	int3   
ffffffffc00153fa:	cc                   	int3   
ffffffffc00153fb:	cc                   	int3   
ffffffffc00153fc:	cc                   	int3   
ffffffffc00153fd:	cc                   	int3   
ffffffffc00153fe:	cc                   	int3   
ffffffffc00153ff:	cc                   	int3   

ffffffffc0015400 <_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h28951a449b1a9858E>:
ffffffffc0015400:	8b 3f                	mov    edi,DWORD PTR [rdi]
ffffffffc0015402:	48 89 f2             	mov    rdx,rsi
ffffffffc0015405:	be 01 00 00 00       	mov    esi,0x1
ffffffffc001540a:	e9 c1 fd ff ff       	jmp    ffffffffc00151d0 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150>
ffffffffc001540f:	cc                   	int3   

ffffffffc0015410 <_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u64$GT$3fmt17hf1643dd746945879E>:
ffffffffc0015410:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
ffffffffc0015413:	48 89 f2             	mov    rdx,rsi
ffffffffc0015416:	be 01 00 00 00       	mov    esi,0x1
ffffffffc001541b:	e9 b0 fd ff ff       	jmp    ffffffffc00151d0 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150>

ffffffffc0015420 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE>:
ffffffffc0015420:	41 56                	push   r14
ffffffffc0015422:	53                   	push   rbx
ffffffffc0015423:	48 83 ec 38          	sub    rsp,0x38
ffffffffc0015427:	8b 46 30             	mov    eax,DWORD PTR [rsi+0x30]
ffffffffc001542a:	48 89 f3             	mov    rbx,rsi
ffffffffc001542d:	49 89 fe             	mov    r14,rdi
ffffffffc0015430:	a8 10                	test   al,0x10
ffffffffc0015432:	75 1a                	jne    ffffffffc001544e <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x2e>
ffffffffc0015434:	a8 20                	test   al,0x20
ffffffffc0015436:	75 27                	jne    ffffffffc001545f <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x3f>
ffffffffc0015438:	49 8b 3e             	mov    rdi,QWORD PTR [r14]
ffffffffc001543b:	be 01 00 00 00       	mov    esi,0x1
ffffffffc0015440:	48 89 da             	mov    rdx,rbx
ffffffffc0015443:	e8 88 fd ff ff       	call   ffffffffc00151d0 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150>
ffffffffc0015448:	84 c0                	test   al,al
ffffffffc001544a:	74 22                	je     ffffffffc001546e <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x4e>
ffffffffc001544c:	eb 63                	jmp    ffffffffc00154b1 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x91>
ffffffffc001544e:	49 8b 3e             	mov    rdi,QWORD PTR [r14]
ffffffffc0015451:	48 89 de             	mov    rsi,rbx
ffffffffc0015454:	e8 e7 db ff ff       	call   ffffffffc0013040 <_ZN4core3fmt3num12GenericRadix7fmt_int17h687cf171525b98aaE.llvm.17464636063181802738>
ffffffffc0015459:	84 c0                	test   al,al
ffffffffc001545b:	74 11                	je     ffffffffc001546e <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x4e>
ffffffffc001545d:	eb 52                	jmp    ffffffffc00154b1 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x91>
ffffffffc001545f:	49 8b 3e             	mov    rdi,QWORD PTR [r14]
ffffffffc0015462:	48 89 de             	mov    rsi,rbx
ffffffffc0015465:	e8 66 dc ff ff       	call   ffffffffc00130d0 <_ZN4core3fmt3num12GenericRadix7fmt_int17h8b72c24675466247E.llvm.17464636063181802738>
ffffffffc001546a:	84 c0                	test   al,al
ffffffffc001546c:	75 43                	jne    ffffffffc00154b1 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x91>
ffffffffc001546e:	48 8b 7b 20          	mov    rdi,QWORD PTR [rbx+0x20]
ffffffffc0015472:	48 8b 73 28          	mov    rsi,QWORD PTR [rbx+0x28]
ffffffffc0015476:	48 8d 54 24 08       	lea    rdx,[rsp+0x8]
ffffffffc001547b:	48 c7 44 24 08 38 8a 	mov    QWORD PTR [rsp+0x8],0xffffffffc0018a38
ffffffffc0015482:	01 c0 
ffffffffc0015484:	48 c7 44 24 10 01 00 	mov    QWORD PTR [rsp+0x10],0x1
ffffffffc001548b:	00 00 
ffffffffc001548d:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
ffffffffc0015494:	00 00 
ffffffffc0015496:	48 c7 44 24 28 48 8a 	mov    QWORD PTR [rsp+0x28],0xffffffffc0018a48
ffffffffc001549d:	01 c0 
ffffffffc001549f:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc00154a6:	00 00 
ffffffffc00154a8:	e8 53 de ff ff       	call   ffffffffc0013300 <_ZN4core3fmt5write17h8b8d8ee2e57eacecE>
ffffffffc00154ad:	84 c0                	test   al,al
ffffffffc00154af:	74 0a                	je     ffffffffc00154bb <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x9b>
ffffffffc00154b1:	b0 01                	mov    al,0x1
ffffffffc00154b3:	48 83 c4 38          	add    rsp,0x38
ffffffffc00154b7:	5b                   	pop    rbx
ffffffffc00154b8:	41 5e                	pop    r14
ffffffffc00154ba:	c3                   	ret    
ffffffffc00154bb:	8b 43 30             	mov    eax,DWORD PTR [rbx+0x30]
ffffffffc00154be:	a8 10                	test   al,0x10
ffffffffc00154c0:	75 1b                	jne    ffffffffc00154dd <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0xbd>
ffffffffc00154c2:	a8 20                	test   al,0x20
ffffffffc00154c4:	75 29                	jne    ffffffffc00154ef <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0xcf>
ffffffffc00154c6:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
ffffffffc00154ca:	be 01 00 00 00       	mov    esi,0x1
ffffffffc00154cf:	48 89 da             	mov    rdx,rbx
ffffffffc00154d2:	e8 f9 fc ff ff       	call   ffffffffc00151d0 <_ZN4core3fmt3num3imp7fmt_u6417hbdcb443770fb53b9E.llvm.14834836203371451150>
ffffffffc00154d7:	84 c0                	test   al,al
ffffffffc00154d9:	75 d6                	jne    ffffffffc00154b1 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x91>
ffffffffc00154db:	eb 22                	jmp    ffffffffc00154ff <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0xdf>
ffffffffc00154dd:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
ffffffffc00154e1:	48 89 de             	mov    rsi,rbx
ffffffffc00154e4:	e8 57 db ff ff       	call   ffffffffc0013040 <_ZN4core3fmt3num12GenericRadix7fmt_int17h687cf171525b98aaE.llvm.17464636063181802738>
ffffffffc00154e9:	84 c0                	test   al,al
ffffffffc00154eb:	75 c4                	jne    ffffffffc00154b1 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x91>
ffffffffc00154ed:	eb 10                	jmp    ffffffffc00154ff <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0xdf>
ffffffffc00154ef:	49 8b 7e 08          	mov    rdi,QWORD PTR [r14+0x8]
ffffffffc00154f3:	48 89 de             	mov    rsi,rbx
ffffffffc00154f6:	e8 d5 db ff ff       	call   ffffffffc00130d0 <_ZN4core3fmt3num12GenericRadix7fmt_int17h8b72c24675466247E.llvm.17464636063181802738>
ffffffffc00154fb:	84 c0                	test   al,al
ffffffffc00154fd:	75 b2                	jne    ffffffffc00154b1 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x91>
ffffffffc00154ff:	31 c0                	xor    eax,eax
ffffffffc0015501:	eb b0                	jmp    ffffffffc00154b3 <_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h1247f5530fcebb9cE+0x93>
ffffffffc0015503:	cc                   	int3   
ffffffffc0015504:	cc                   	int3   
ffffffffc0015505:	cc                   	int3   
ffffffffc0015506:	cc                   	int3   
ffffffffc0015507:	cc                   	int3   
ffffffffc0015508:	cc                   	int3   
ffffffffc0015509:	cc                   	int3   
ffffffffc001550a:	cc                   	int3   
ffffffffc001550b:	cc                   	int3   
ffffffffc001550c:	cc                   	int3   
ffffffffc001550d:	cc                   	int3   
ffffffffc001550e:	cc                   	int3   
ffffffffc001550f:	cc                   	int3   

ffffffffc0015510 <_ZN4core5slice5index26slice_start_index_len_fail17hfbe4f54d0d3768aaE>:
ffffffffc0015510:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0015514:	e8 37 fa ff ff       	call   ffffffffc0014f50 <_ZN4core10intrinsics17const_eval_select17h53979d727fcb3488E>
ffffffffc0015519:	0f 0b                	ud2    
ffffffffc001551b:	cc                   	int3   
ffffffffc001551c:	cc                   	int3   
ffffffffc001551d:	cc                   	int3   
ffffffffc001551e:	cc                   	int3   
ffffffffc001551f:	cc                   	int3   

ffffffffc0015520 <_ZN4core5slice5index29slice_start_index_len_fail_rt17h97395a01743838cdE>:
ffffffffc0015520:	48 83 ec 68          	sub    rsp,0x68
ffffffffc0015524:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0015529:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc001552e:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc0015533:	48 8d 54 24 10       	lea    rdx,[rsp+0x10]
ffffffffc0015538:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc001553d:	48 8d 7c 24 38       	lea    rdi,[rsp+0x38]
ffffffffc0015542:	48 c7 c6 18 8b 01 c0 	mov    rsi,0xffffffffc0018b18
ffffffffc0015549:	48 c7 44 24 38 80 8a 	mov    QWORD PTR [rsp+0x38],0xffffffffc0018a80
ffffffffc0015550:	01 c0 
ffffffffc0015552:	48 c7 44 24 40 02 00 	mov    QWORD PTR [rsp+0x40],0x2
ffffffffc0015559:	00 00 
ffffffffc001555b:	48 c7 44 24 48 00 00 	mov    QWORD PTR [rsp+0x48],0x0
ffffffffc0015562:	00 00 
ffffffffc0015564:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc0015569:	48 c7 44 24 20 10 54 	mov    QWORD PTR [rsp+0x20],0xffffffffc0015410
ffffffffc0015570:	01 c0 
ffffffffc0015572:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
ffffffffc0015577:	48 89 4c 24 58       	mov    QWORD PTR [rsp+0x58],rcx
ffffffffc001557c:	48 c7 44 24 30 10 54 	mov    QWORD PTR [rsp+0x30],0xffffffffc0015410
ffffffffc0015583:	01 c0 
ffffffffc0015585:	48 c7 44 24 60 02 00 	mov    QWORD PTR [rsp+0x60],0x2
ffffffffc001558c:	00 00 
ffffffffc001558e:	e8 6d f1 ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0015593:	0f 0b                	ud2    
ffffffffc0015595:	cc                   	int3   
ffffffffc0015596:	cc                   	int3   
ffffffffc0015597:	cc                   	int3   
ffffffffc0015598:	cc                   	int3   
ffffffffc0015599:	cc                   	int3   
ffffffffc001559a:	cc                   	int3   
ffffffffc001559b:	cc                   	int3   
ffffffffc001559c:	cc                   	int3   
ffffffffc001559d:	cc                   	int3   
ffffffffc001559e:	cc                   	int3   
ffffffffc001559f:	cc                   	int3   

ffffffffc00155a0 <_ZN4core5slice5index24slice_end_index_len_fail17hdc06d5317026ab27E>:
ffffffffc00155a0:	48 83 ec 08          	sub    rsp,0x8
ffffffffc00155a4:	e8 97 f9 ff ff       	call   ffffffffc0014f40 <_ZN4core10intrinsics17const_eval_select17h47d2d46d4807ad98E>
ffffffffc00155a9:	0f 0b                	ud2    
ffffffffc00155ab:	cc                   	int3   
ffffffffc00155ac:	cc                   	int3   
ffffffffc00155ad:	cc                   	int3   
ffffffffc00155ae:	cc                   	int3   
ffffffffc00155af:	cc                   	int3   

ffffffffc00155b0 <_ZN4core5slice5index27slice_end_index_len_fail_rt17h63889dc279182820E>:
ffffffffc00155b0:	48 83 ec 68          	sub    rsp,0x68
ffffffffc00155b4:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc00155b9:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc00155be:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc00155c3:	48 8d 54 24 10       	lea    rdx,[rsp+0x10]
ffffffffc00155c8:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc00155cd:	48 8d 7c 24 38       	lea    rdi,[rsp+0x38]
ffffffffc00155d2:	48 c7 c6 50 8b 01 c0 	mov    rsi,0xffffffffc0018b50
ffffffffc00155d9:	48 c7 44 24 38 30 8b 	mov    QWORD PTR [rsp+0x38],0xffffffffc0018b30
ffffffffc00155e0:	01 c0 
ffffffffc00155e2:	48 c7 44 24 40 02 00 	mov    QWORD PTR [rsp+0x40],0x2
ffffffffc00155e9:	00 00 
ffffffffc00155eb:	48 c7 44 24 48 00 00 	mov    QWORD PTR [rsp+0x48],0x0
ffffffffc00155f2:	00 00 
ffffffffc00155f4:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc00155f9:	48 c7 44 24 20 10 54 	mov    QWORD PTR [rsp+0x20],0xffffffffc0015410
ffffffffc0015600:	01 c0 
ffffffffc0015602:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
ffffffffc0015607:	48 89 4c 24 58       	mov    QWORD PTR [rsp+0x58],rcx
ffffffffc001560c:	48 c7 44 24 30 10 54 	mov    QWORD PTR [rsp+0x30],0xffffffffc0015410
ffffffffc0015613:	01 c0 
ffffffffc0015615:	48 c7 44 24 60 02 00 	mov    QWORD PTR [rsp+0x60],0x2
ffffffffc001561c:	00 00 
ffffffffc001561e:	e8 dd f0 ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0015623:	0f 0b                	ud2    
ffffffffc0015625:	cc                   	int3   
ffffffffc0015626:	cc                   	int3   
ffffffffc0015627:	cc                   	int3   
ffffffffc0015628:	cc                   	int3   
ffffffffc0015629:	cc                   	int3   
ffffffffc001562a:	cc                   	int3   
ffffffffc001562b:	cc                   	int3   
ffffffffc001562c:	cc                   	int3   
ffffffffc001562d:	cc                   	int3   
ffffffffc001562e:	cc                   	int3   
ffffffffc001562f:	cc                   	int3   

ffffffffc0015630 <_ZN4core5slice5index22slice_index_order_fail17hc351c406b61d0e9fE>:
ffffffffc0015630:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0015634:	e8 27 f9 ff ff       	call   ffffffffc0014f60 <_ZN4core10intrinsics17const_eval_select17h749e253dcc334a1dE>
ffffffffc0015639:	0f 0b                	ud2    
ffffffffc001563b:	cc                   	int3   
ffffffffc001563c:	cc                   	int3   
ffffffffc001563d:	cc                   	int3   
ffffffffc001563e:	cc                   	int3   
ffffffffc001563f:	cc                   	int3   

ffffffffc0015640 <_ZN4core5slice5index25slice_index_order_fail_rt17hd7cf48772c620f0eE>:
ffffffffc0015640:	48 83 ec 68          	sub    rsp,0x68
ffffffffc0015644:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0015649:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc001564e:	48 8d 44 24 08       	lea    rax,[rsp+0x8]
ffffffffc0015653:	48 8d 54 24 10       	lea    rdx,[rsp+0x10]
ffffffffc0015658:	48 8d 4c 24 18       	lea    rcx,[rsp+0x18]
ffffffffc001565d:	48 8d 7c 24 38       	lea    rdi,[rsp+0x38]
ffffffffc0015662:	48 c7 c6 b0 8b 01 c0 	mov    rsi,0xffffffffc0018bb0
ffffffffc0015669:	48 c7 44 24 38 90 8b 	mov    QWORD PTR [rsp+0x38],0xffffffffc0018b90
ffffffffc0015670:	01 c0 
ffffffffc0015672:	48 c7 44 24 40 02 00 	mov    QWORD PTR [rsp+0x40],0x2
ffffffffc0015679:	00 00 
ffffffffc001567b:	48 c7 44 24 48 00 00 	mov    QWORD PTR [rsp+0x48],0x0
ffffffffc0015682:	00 00 
ffffffffc0015684:	48 89 44 24 18       	mov    QWORD PTR [rsp+0x18],rax
ffffffffc0015689:	48 c7 44 24 20 10 54 	mov    QWORD PTR [rsp+0x20],0xffffffffc0015410
ffffffffc0015690:	01 c0 
ffffffffc0015692:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
ffffffffc0015697:	48 89 4c 24 58       	mov    QWORD PTR [rsp+0x58],rcx
ffffffffc001569c:	48 c7 44 24 30 10 54 	mov    QWORD PTR [rsp+0x30],0xffffffffc0015410
ffffffffc00156a3:	01 c0 
ffffffffc00156a5:	48 c7 44 24 60 02 00 	mov    QWORD PTR [rsp+0x60],0x2
ffffffffc00156ac:	00 00 
ffffffffc00156ae:	e8 4d f0 ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc00156b3:	0f 0b                	ud2    
ffffffffc00156b5:	cc                   	int3   
ffffffffc00156b6:	cc                   	int3   
ffffffffc00156b7:	cc                   	int3   
ffffffffc00156b8:	cc                   	int3   
ffffffffc00156b9:	cc                   	int3   
ffffffffc00156ba:	cc                   	int3   
ffffffffc00156bb:	cc                   	int3   
ffffffffc00156bc:	cc                   	int3   
ffffffffc00156bd:	cc                   	int3   
ffffffffc00156be:	cc                   	int3   
ffffffffc00156bf:	cc                   	int3   

ffffffffc00156c0 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E>:
ffffffffc00156c0:	48 83 ec 08          	sub    rsp,0x8
ffffffffc00156c4:	48 8b 17             	mov    rdx,QWORD PTR [rdi]
ffffffffc00156c7:	48 8b 77 08          	mov    rsi,QWORD PTR [rdi+0x8]
ffffffffc00156cb:	48 39 f2             	cmp    rdx,rsi
ffffffffc00156ce:	0f 84 82 00 00 00    	je     ffffffffc0015756 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0x96>
ffffffffc00156d4:	48 8d 4a 01          	lea    rcx,[rdx+0x1]
ffffffffc00156d8:	48 89 0f             	mov    QWORD PTR [rdi],rcx
ffffffffc00156db:	0f b6 02             	movzx  eax,BYTE PTR [rdx]
ffffffffc00156de:	84 c0                	test   al,al
ffffffffc00156e0:	0f 89 8d 00 00 00    	jns    ffffffffc0015773 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xb3>
ffffffffc00156e6:	48 39 f1             	cmp    rcx,rsi
ffffffffc00156e9:	0f 84 bd 00 00 00    	je     ffffffffc00157ac <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xec>
ffffffffc00156ef:	4c 8d 42 02          	lea    r8,[rdx+0x2]
ffffffffc00156f3:	41 89 c1             	mov    r9d,eax
ffffffffc00156f6:	4c 89 07             	mov    QWORD PTR [rdi],r8
ffffffffc00156f9:	41 83 e1 1f          	and    r9d,0x1f
ffffffffc00156fd:	0f b6 4a 01          	movzx  ecx,BYTE PTR [rdx+0x1]
ffffffffc0015701:	83 e1 3f             	and    ecx,0x3f
ffffffffc0015704:	3c df                	cmp    al,0xdf
ffffffffc0015706:	76 55                	jbe    ffffffffc001575d <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0x9d>
ffffffffc0015708:	49 39 f0             	cmp    r8,rsi
ffffffffc001570b:	0f 84 b5 00 00 00    	je     ffffffffc00157c6 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0x106>
ffffffffc0015711:	4c 8d 52 03          	lea    r10,[rdx+0x3]
ffffffffc0015715:	c1 e1 06             	shl    ecx,0x6
ffffffffc0015718:	4c 89 17             	mov    QWORD PTR [rdi],r10
ffffffffc001571b:	44 0f b6 42 02       	movzx  r8d,BYTE PTR [rdx+0x2]
ffffffffc0015720:	41 83 e0 3f          	and    r8d,0x3f
ffffffffc0015724:	41 09 c8             	or     r8d,ecx
ffffffffc0015727:	3c f0                	cmp    al,0xf0
ffffffffc0015729:	72 3e                	jb     ffffffffc0015769 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xa9>
ffffffffc001572b:	49 39 f2             	cmp    r10,rsi
ffffffffc001572e:	0f 84 ac 00 00 00    	je     ffffffffc00157e0 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0x120>
ffffffffc0015734:	48 8d 42 04          	lea    rax,[rdx+0x4]
ffffffffc0015738:	41 83 e1 07          	and    r9d,0x7
ffffffffc001573c:	41 c1 e0 06          	shl    r8d,0x6
ffffffffc0015740:	48 89 07             	mov    QWORD PTR [rdi],rax
ffffffffc0015743:	41 c1 e1 12          	shl    r9d,0x12
ffffffffc0015747:	0f b6 42 03          	movzx  eax,BYTE PTR [rdx+0x3]
ffffffffc001574b:	83 e0 3f             	and    eax,0x3f
ffffffffc001574e:	44 09 c0             	or     eax,r8d
ffffffffc0015751:	44 09 c8             	or     eax,r9d
ffffffffc0015754:	eb 1d                	jmp    ffffffffc0015773 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xb3>
ffffffffc0015756:	b8 00 00 11 00       	mov    eax,0x110000
ffffffffc001575b:	59                   	pop    rcx
ffffffffc001575c:	c3                   	ret    
ffffffffc001575d:	41 c1 e1 06          	shl    r9d,0x6
ffffffffc0015761:	41 09 c9             	or     r9d,ecx
ffffffffc0015764:	44 89 c8             	mov    eax,r9d
ffffffffc0015767:	eb 0a                	jmp    ffffffffc0015773 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xb3>
ffffffffc0015769:	41 c1 e1 0c          	shl    r9d,0xc
ffffffffc001576d:	45 09 c8             	or     r8d,r9d
ffffffffc0015770:	44 89 c0             	mov    eax,r8d
ffffffffc0015773:	89 c1                	mov    ecx,eax
ffffffffc0015775:	81 f1 00 d8 00 00    	xor    ecx,0xd800
ffffffffc001577b:	81 c1 00 00 ef ff    	add    ecx,0xffef0000
ffffffffc0015781:	81 f9 00 08 ef ff    	cmp    ecx,0xffef0800
ffffffffc0015787:	72 09                	jb     ffffffffc0015792 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xd2>
ffffffffc0015789:	3d 00 00 11 00       	cmp    eax,0x110000
ffffffffc001578e:	74 02                	je     ffffffffc0015792 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E+0xd2>
ffffffffc0015790:	59                   	pop    rcx
ffffffffc0015791:	c3                   	ret    
ffffffffc0015792:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc0015797:	48 c7 c7 a0 8c 01 c0 	mov    rdi,0xffffffffc0018ca0
ffffffffc001579e:	48 c7 c2 88 8c 01 c0 	mov    rdx,0xffffffffc0018c88
ffffffffc00157a5:	e8 86 ee ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00157aa:	0f 0b                	ud2    
ffffffffc00157ac:	be 20 00 00 00       	mov    esi,0x20
ffffffffc00157b1:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc00157b8:	48 c7 c2 80 8e 01 c0 	mov    rdx,0xffffffffc0018e80
ffffffffc00157bf:	e8 6c ee ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00157c4:	0f 0b                	ud2    
ffffffffc00157c6:	be 20 00 00 00       	mov    esi,0x20
ffffffffc00157cb:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc00157d2:	48 c7 c2 98 8e 01 c0 	mov    rdx,0xffffffffc0018e98
ffffffffc00157d9:	e8 52 ee ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00157de:	0f 0b                	ud2    
ffffffffc00157e0:	be 20 00 00 00       	mov    esi,0x20
ffffffffc00157e5:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc00157ec:	48 c7 c2 b0 8e 01 c0 	mov    rdx,0xffffffffc0018eb0
ffffffffc00157f3:	e8 38 ee ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc00157f8:	0f 0b                	ud2    
ffffffffc00157fa:	cc                   	int3   
ffffffffc00157fb:	cc                   	int3   
ffffffffc00157fc:	cc                   	int3   
ffffffffc00157fd:	cc                   	int3   
ffffffffc00157fe:	cc                   	int3   
ffffffffc00157ff:	cc                   	int3   

ffffffffc0015800 <_ZN4core3str16slice_error_fail17h5f3f742159a9ffe5E>:
ffffffffc0015800:	48 83 ec 28          	sub    rsp,0x28
ffffffffc0015804:	48 89 7c 24 08       	mov    QWORD PTR [rsp+0x8],rdi
ffffffffc0015809:	48 8d 7c 24 08       	lea    rdi,[rsp+0x8]
ffffffffc001580e:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
ffffffffc0015813:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
ffffffffc0015818:	48 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],rcx
ffffffffc001581d:	e8 4e f7 ff ff       	call   ffffffffc0014f70 <_ZN4core10intrinsics17const_eval_select17h981370acf09ad35dE>
ffffffffc0015822:	0f 0b                	ud2    
ffffffffc0015824:	cc                   	int3   
ffffffffc0015825:	cc                   	int3   
ffffffffc0015826:	cc                   	int3   
ffffffffc0015827:	cc                   	int3   
ffffffffc0015828:	cc                   	int3   
ffffffffc0015829:	cc                   	int3   
ffffffffc001582a:	cc                   	int3   
ffffffffc001582b:	cc                   	int3   
ffffffffc001582c:	cc                   	int3   
ffffffffc001582d:	cc                   	int3   
ffffffffc001582e:	cc                   	int3   
ffffffffc001582f:	cc                   	int3   

ffffffffc0015830 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE>:
ffffffffc0015830:	41 56                	push   r14
ffffffffc0015832:	53                   	push   rbx
ffffffffc0015833:	48 81 ec d8 00 00 00 	sub    rsp,0xd8
ffffffffc001583a:	48 89 94 24 c0 00 00 	mov    QWORD PTR [rsp+0xc0],rdx
ffffffffc0015841:	00 
ffffffffc0015842:	48 89 8c 24 c8 00 00 	mov    QWORD PTR [rsp+0xc8],rcx
ffffffffc0015849:	00 
ffffffffc001584a:	48 81 fe 01 01 00 00 	cmp    rsi,0x101
ffffffffc0015851:	72 5e                	jb     ffffffffc00158b1 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x81>
ffffffffc0015853:	80 bf 00 01 00 00 bf 	cmp    BYTE PTR [rdi+0x100],0xbf
ffffffffc001585a:	41 b8 00 01 00 00    	mov    r8d,0x100
ffffffffc0015860:	7f 31                	jg     ffffffffc0015893 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x63>
ffffffffc0015862:	80 bf ff 00 00 00 bf 	cmp    BYTE PTR [rdi+0xff],0xbf
ffffffffc0015869:	41 b8 ff 00 00 00    	mov    r8d,0xff
ffffffffc001586f:	7f 22                	jg     ffffffffc0015893 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x63>
ffffffffc0015871:	80 bf fe 00 00 00 bf 	cmp    BYTE PTR [rdi+0xfe],0xbf
ffffffffc0015878:	41 b8 fe 00 00 00    	mov    r8d,0xfe
ffffffffc001587e:	7f 13                	jg     ffffffffc0015893 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x63>
ffffffffc0015880:	80 bf fd 00 00 00 bf 	cmp    BYTE PTR [rdi+0xfd],0xbf
ffffffffc0015887:	41 b8 fd 00 00 00    	mov    r8d,0xfd
ffffffffc001588d:	0f 8e 34 02 00 00    	jle    ffffffffc0015ac7 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x297>
ffffffffc0015893:	49 39 f0             	cmp    r8,rsi
ffffffffc0015896:	73 2e                	jae    ffffffffc00158c6 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x96>
ffffffffc0015898:	42 80 3c 07 bf       	cmp    BYTE PTR [rdi+r8*1],0xbf
ffffffffc001589d:	0f 8e e5 00 00 00    	jle    ffffffffc0015988 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x158>
ffffffffc00158a3:	48 c7 c3 40 8f 01 c0 	mov    rbx,0xffffffffc0018f40
ffffffffc00158aa:	b8 05 00 00 00       	mov    eax,0x5
ffffffffc00158af:	eb 24                	jmp    ffffffffc00158d5 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0xa5>
ffffffffc00158b1:	48 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],rdi
ffffffffc00158b6:	48 89 74 24 18       	mov    QWORD PTR [rsp+0x18],rsi
ffffffffc00158bb:	48 c7 c3 d0 8c 01 c0 	mov    rbx,0xffffffffc0018cd0
ffffffffc00158c2:	31 c0                	xor    eax,eax
ffffffffc00158c4:	eb 19                	jmp    ffffffffc00158df <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0xaf>
ffffffffc00158c6:	0f 85 bc 00 00 00    	jne    ffffffffc0015988 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x158>
ffffffffc00158cc:	48 c7 c3 d0 8c 01 c0 	mov    rbx,0xffffffffc0018cd0
ffffffffc00158d3:	31 c0                	xor    eax,eax
ffffffffc00158d5:	48 89 7c 24 10       	mov    QWORD PTR [rsp+0x10],rdi
ffffffffc00158da:	4c 89 44 24 18       	mov    QWORD PTR [rsp+0x18],r8
ffffffffc00158df:	48 89 9c 24 a0 00 00 	mov    QWORD PTR [rsp+0xa0],rbx
ffffffffc00158e6:	00 
ffffffffc00158e7:	48 89 84 24 a8 00 00 	mov    QWORD PTR [rsp+0xa8],rax
ffffffffc00158ee:	00 
ffffffffc00158ef:	48 39 f2             	cmp    rdx,rsi
ffffffffc00158f2:	77 0c                	ja     ffffffffc0015900 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0xd0>
ffffffffc00158f4:	48 39 f1             	cmp    rcx,rsi
ffffffffc00158f7:	0f 86 97 00 00 00    	jbe    ffffffffc0015994 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x164>
ffffffffc00158fd:	48 89 ca             	mov    rdx,rcx
ffffffffc0015900:	48 8d 84 24 b0 00 00 	lea    rax,[rsp+0xb0]
ffffffffc0015907:	00 
ffffffffc0015908:	48 8d 4c 24 10       	lea    rcx,[rsp+0x10]
ffffffffc001590d:	48 89 94 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rdx
ffffffffc0015914:	00 
ffffffffc0015915:	48 8d 94 24 a0 00 00 	lea    rdx,[rsp+0xa0]
ffffffffc001591c:	00 
ffffffffc001591d:	48 8d 7c 24 20       	lea    rdi,[rsp+0x20]
ffffffffc0015922:	48 c7 c6 98 8f 01 c0 	mov    rsi,0xffffffffc0018f98
ffffffffc0015929:	48 c7 44 24 20 68 8f 	mov    QWORD PTR [rsp+0x20],0xffffffffc0018f68
ffffffffc0015930:	01 c0 
ffffffffc0015932:	48 c7 44 24 28 03 00 	mov    QWORD PTR [rsp+0x28],0x3
ffffffffc0015939:	00 00 
ffffffffc001593b:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc0015942:	00 00 
ffffffffc0015944:	48 89 44 24 50       	mov    QWORD PTR [rsp+0x50],rax
ffffffffc0015949:	48 c7 44 24 58 10 54 	mov    QWORD PTR [rsp+0x58],0xffffffffc0015410
ffffffffc0015950:	01 c0 
ffffffffc0015952:	48 89 4c 24 60       	mov    QWORD PTR [rsp+0x60],rcx
ffffffffc0015957:	48 8d 4c 24 50       	lea    rcx,[rsp+0x50]
ffffffffc001595c:	48 c7 44 24 68 e0 45 	mov    QWORD PTR [rsp+0x68],0xffffffffc00145e0
ffffffffc0015963:	01 c0 
ffffffffc0015965:	48 89 54 24 70       	mov    QWORD PTR [rsp+0x70],rdx
ffffffffc001596a:	48 c7 44 24 78 e0 45 	mov    QWORD PTR [rsp+0x78],0xffffffffc00145e0
ffffffffc0015971:	01 c0 
ffffffffc0015973:	48 89 4c 24 40       	mov    QWORD PTR [rsp+0x40],rcx
ffffffffc0015978:	48 c7 44 24 48 03 00 	mov    QWORD PTR [rsp+0x48],0x3
ffffffffc001597f:	00 00 
ffffffffc0015981:	e8 7a ed ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0015986:	0f 0b                	ud2    
ffffffffc0015988:	31 d2                	xor    edx,edx
ffffffffc001598a:	4c 89 c1             	mov    rcx,r8
ffffffffc001598d:	e8 6e fe ff ff       	call   ffffffffc0015800 <_ZN4core3str16slice_error_fail17h5f3f742159a9ffe5E>
ffffffffc0015992:	0f 0b                	ud2    
ffffffffc0015994:	48 39 ca             	cmp    rdx,rcx
ffffffffc0015997:	0f 86 9c 00 00 00    	jbe    ffffffffc0015a39 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x209>
ffffffffc001599d:	48 8d 84 24 c0 00 00 	lea    rax,[rsp+0xc0]
ffffffffc00159a4:	00 
ffffffffc00159a5:	48 8d 94 24 c8 00 00 	lea    rdx,[rsp+0xc8]
ffffffffc00159ac:	00 
ffffffffc00159ad:	48 8d 4c 24 10       	lea    rcx,[rsp+0x10]
ffffffffc00159b2:	48 8d 7c 24 20       	lea    rdi,[rsp+0x20]
ffffffffc00159b7:	48 c7 c6 00 90 01 c0 	mov    rsi,0xffffffffc0019000
ffffffffc00159be:	48 c7 44 24 20 c0 8f 	mov    QWORD PTR [rsp+0x20],0xffffffffc0018fc0
ffffffffc00159c5:	01 c0 
ffffffffc00159c7:	48 c7 44 24 28 04 00 	mov    QWORD PTR [rsp+0x28],0x4
ffffffffc00159ce:	00 00 
ffffffffc00159d0:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc00159d7:	00 00 
ffffffffc00159d9:	48 89 44 24 50       	mov    QWORD PTR [rsp+0x50],rax
ffffffffc00159de:	48 c7 44 24 58 10 54 	mov    QWORD PTR [rsp+0x58],0xffffffffc0015410
ffffffffc00159e5:	01 c0 
ffffffffc00159e7:	48 89 54 24 60       	mov    QWORD PTR [rsp+0x60],rdx
ffffffffc00159ec:	48 c7 44 24 68 10 54 	mov    QWORD PTR [rsp+0x68],0xffffffffc0015410
ffffffffc00159f3:	01 c0 
ffffffffc00159f5:	48 89 4c 24 70       	mov    QWORD PTR [rsp+0x70],rcx
ffffffffc00159fa:	48 8d 4c 24 50       	lea    rcx,[rsp+0x50]
ffffffffc00159ff:	48 8d 94 24 a0 00 00 	lea    rdx,[rsp+0xa0]
ffffffffc0015a06:	00 
ffffffffc0015a07:	48 c7 44 24 78 e0 45 	mov    QWORD PTR [rsp+0x78],0xffffffffc00145e0
ffffffffc0015a0e:	01 c0 
ffffffffc0015a10:	48 89 94 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rdx
ffffffffc0015a17:	00 
ffffffffc0015a18:	48 89 4c 24 40       	mov    QWORD PTR [rsp+0x40],rcx
ffffffffc0015a1d:	48 c7 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],0xffffffffc00145e0
ffffffffc0015a24:	00 e0 45 01 c0 
ffffffffc0015a29:	48 c7 44 24 48 04 00 	mov    QWORD PTR [rsp+0x48],0x4
ffffffffc0015a30:	00 00 
ffffffffc0015a32:	e8 c9 ec ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0015a37:	0f 0b                	ud2    
ffffffffc0015a39:	48 85 d2             	test   rdx,rdx
ffffffffc0015a3c:	74 0f                	je     ffffffffc0015a4d <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x21d>
ffffffffc0015a3e:	48 39 f2             	cmp    rdx,rsi
ffffffffc0015a41:	73 08                	jae    ffffffffc0015a4b <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x21b>
ffffffffc0015a43:	80 3c 17 bf          	cmp    BYTE PTR [rdi+rdx*1],0xbf
ffffffffc0015a47:	7f 04                	jg     ffffffffc0015a4d <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x21d>
ffffffffc0015a49:	eb 05                	jmp    ffffffffc0015a50 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x220>
ffffffffc0015a4b:	75 03                	jne    ffffffffc0015a50 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x220>
ffffffffc0015a4d:	48 89 ca             	mov    rdx,rcx
ffffffffc0015a50:	48 89 f3             	mov    rbx,rsi
ffffffffc0015a53:	48 89 94 24 d0 00 00 	mov    QWORD PTR [rsp+0xd0],rdx
ffffffffc0015a5a:	00 
ffffffffc0015a5b:	48 39 f2             	cmp    rdx,rsi
ffffffffc0015a5e:	73 4a                	jae    ffffffffc0015aaa <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x27a>
ffffffffc0015a60:	48 89 d0             	mov    rax,rdx
ffffffffc0015a63:	31 db                	xor    ebx,ebx
ffffffffc0015a65:	48 83 e8 03          	sub    rax,0x3
ffffffffc0015a69:	48 0f 43 d8          	cmovae rbx,rax
ffffffffc0015a6d:	48 8d 42 01          	lea    rax,[rdx+0x1]
ffffffffc0015a71:	48 89 c1             	mov    rcx,rax
ffffffffc0015a74:	48 29 d9             	sub    rcx,rbx
ffffffffc0015a77:	73 14                	jae    ffffffffc0015a8d <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x25d>
ffffffffc0015a79:	48 89 df             	mov    rdi,rbx
ffffffffc0015a7c:	48 89 c6             	mov    rsi,rax
ffffffffc0015a7f:	48 c7 c2 e0 90 01 c0 	mov    rdx,0xffffffffc00190e0
ffffffffc0015a86:	e8 a5 fb ff ff       	call   ffffffffc0015630 <_ZN4core5slice5index22slice_index_order_fail17hc351c406b61d0e9fE>
ffffffffc0015a8b:	0f 0b                	ud2    
ffffffffc0015a8d:	48 01 fa             	add    rdx,rdi
ffffffffc0015a90:	48 85 c9             	test   rcx,rcx
ffffffffc0015a93:	74 32                	je     ffffffffc0015ac7 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x297>
ffffffffc0015a95:	48 ff c9             	dec    rcx
ffffffffc0015a98:	80 3a bf             	cmp    BYTE PTR [rdx],0xbf
ffffffffc0015a9b:	48 8d 52 ff          	lea    rdx,[rdx-0x1]
ffffffffc0015a9f:	7e ef                	jle    ffffffffc0015a90 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x260>
ffffffffc0015aa1:	48 01 cb             	add    rbx,rcx
ffffffffc0015aa4:	0f 82 a7 01 00 00    	jb     ffffffffc0015c51 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x421>
ffffffffc0015aaa:	48 85 db             	test   rbx,rbx
ffffffffc0015aad:	74 34                	je     ffffffffc0015ae3 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x2b3>
ffffffffc0015aaf:	48 39 f3             	cmp    rbx,rsi
ffffffffc0015ab2:	73 2d                	jae    ffffffffc0015ae1 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x2b1>
ffffffffc0015ab4:	80 3c 1f bf          	cmp    BYTE PTR [rdi+rbx*1],0xbf
ffffffffc0015ab8:	7f 29                	jg     ffffffffc0015ae3 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x2b3>
ffffffffc0015aba:	48 89 da             	mov    rdx,rbx
ffffffffc0015abd:	48 89 f1             	mov    rcx,rsi
ffffffffc0015ac0:	e8 3b fd ff ff       	call   ffffffffc0015800 <_ZN4core3str16slice_error_fail17h5f3f742159a9ffe5E>
ffffffffc0015ac5:	0f 0b                	ud2    
ffffffffc0015ac7:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0015acc:	48 c7 c7 50 6c 01 c0 	mov    rdi,0xffffffffc0016c50
ffffffffc0015ad3:	48 c7 c2 f8 90 01 c0 	mov    rdx,0xffffffffc00190f8
ffffffffc0015ada:	e8 51 eb ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015adf:	0f 0b                	ud2    
ffffffffc0015ae1:	75 d7                	jne    ffffffffc0015aba <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x28a>
ffffffffc0015ae3:	48 29 de             	sub    rsi,rbx
ffffffffc0015ae6:	0f 82 31 01 00 00    	jb     ffffffffc0015c1d <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x3ed>
ffffffffc0015aec:	48 01 df             	add    rdi,rbx
ffffffffc0015aef:	4c 8d 74 24 50       	lea    r14,[rsp+0x50]
ffffffffc0015af4:	48 01 fe             	add    rsi,rdi
ffffffffc0015af7:	48 89 7c 24 50       	mov    QWORD PTR [rsp+0x50],rdi
ffffffffc0015afc:	4c 89 f7             	mov    rdi,r14
ffffffffc0015aff:	48 89 74 24 58       	mov    QWORD PTR [rsp+0x58],rsi
ffffffffc0015b04:	e8 b7 fb ff ff       	call   ffffffffc00156c0 <_ZN81_$LT$core..str..iter..Chars$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h52fdbdb227e788c3E>
ffffffffc0015b09:	3d 00 00 11 00       	cmp    eax,0x110000
ffffffffc0015b0e:	75 1a                	jne    ffffffffc0015b2a <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x2fa>
ffffffffc0015b10:	be 2b 00 00 00       	mov    esi,0x2b
ffffffffc0015b15:	48 c7 c7 a0 8c 01 c0 	mov    rdi,0xffffffffc0018ca0
ffffffffc0015b1c:	48 c7 c2 18 90 01 c0 	mov    rdx,0xffffffffc0019018
ffffffffc0015b23:	e8 08 eb ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015b28:	0f 0b                	ud2    
ffffffffc0015b2a:	b9 01 00 00 00       	mov    ecx,0x1
ffffffffc0015b2f:	89 44 24 0c          	mov    DWORD PTR [rsp+0xc],eax
ffffffffc0015b33:	3d 80 00 00 00       	cmp    eax,0x80
ffffffffc0015b38:	72 1a                	jb     ffffffffc0015b54 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x324>
ffffffffc0015b3a:	b9 02 00 00 00       	mov    ecx,0x2
ffffffffc0015b3f:	3d 00 08 00 00       	cmp    eax,0x800
ffffffffc0015b44:	72 0e                	jb     ffffffffc0015b54 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x324>
ffffffffc0015b46:	3d 00 00 01 00       	cmp    eax,0x10000
ffffffffc0015b4b:	b9 04 00 00 00       	mov    ecx,0x4
ffffffffc0015b50:	48 83 d9 00          	sbb    rcx,0x0
ffffffffc0015b54:	48 01 d9             	add    rcx,rbx
ffffffffc0015b57:	0f 82 da 00 00 00    	jb     ffffffffc0015c37 <_ZN4core3str19slice_error_fail_rt17h45476af2f9138ecfE+0x407>
ffffffffc0015b5d:	48 89 9c 24 b0 00 00 	mov    QWORD PTR [rsp+0xb0],rbx
ffffffffc0015b64:	00 
ffffffffc0015b65:	48 89 8c 24 b8 00 00 	mov    QWORD PTR [rsp+0xb8],rcx
ffffffffc0015b6c:	00 
ffffffffc0015b6d:	48 8d 84 24 d0 00 00 	lea    rax,[rsp+0xd0]
ffffffffc0015b74:	00 
ffffffffc0015b75:	48 8d 54 24 0c       	lea    rdx,[rsp+0xc]
ffffffffc0015b7a:	48 8d 8c 24 b0 00 00 	lea    rcx,[rsp+0xb0]
ffffffffc0015b81:	00 
ffffffffc0015b82:	48 8d 7c 24 20       	lea    rdi,[rsp+0x20]
ffffffffc0015b87:	48 c7 c6 c8 90 01 c0 	mov    rsi,0xffffffffc00190c8
ffffffffc0015b8e:	48 c7 44 24 20 78 90 	mov    QWORD PTR [rsp+0x20],0xffffffffc0019078
ffffffffc0015b95:	01 c0 
ffffffffc0015b97:	48 c7 44 24 28 05 00 	mov    QWORD PTR [rsp+0x28],0x5
ffffffffc0015b9e:	00 00 
ffffffffc0015ba0:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
ffffffffc0015ba7:	00 00 
ffffffffc0015ba9:	4c 89 74 24 40       	mov    QWORD PTR [rsp+0x40],r14
ffffffffc0015bae:	48 c7 44 24 48 05 00 	mov    QWORD PTR [rsp+0x48],0x5
ffffffffc0015bb5:	00 00 
ffffffffc0015bb7:	48 89 44 24 50       	mov    QWORD PTR [rsp+0x50],rax
ffffffffc0015bbc:	48 c7 44 24 58 10 54 	mov    QWORD PTR [rsp+0x58],0xffffffffc0015410
ffffffffc0015bc3:	01 c0 
ffffffffc0015bc5:	48 89 54 24 60       	mov    QWORD PTR [rsp+0x60],rdx
ffffffffc0015bca:	48 c7 44 24 68 00 41 	mov    QWORD PTR [rsp+0x68],0xffffffffc0014100
ffffffffc0015bd1:	01 c0 
ffffffffc0015bd3:	48 89 4c 24 70       	mov    QWORD PTR [rsp+0x70],rcx
ffffffffc0015bd8:	48 8d 54 24 10       	lea    rdx,[rsp+0x10]
ffffffffc0015bdd:	48 8d 8c 24 a0 00 00 	lea    rcx,[rsp+0xa0]
ffffffffc0015be4:	00 
ffffffffc0015be5:	48 c7 44 24 78 20 54 	mov    QWORD PTR [rsp+0x78],0xffffffffc0015420
ffffffffc0015bec:	01 c0 
ffffffffc0015bee:	48 89 94 24 80 00 00 	mov    QWORD PTR [rsp+0x80],rdx
ffffffffc0015bf5:	00 
ffffffffc0015bf6:	48 c7 84 24 88 00 00 	mov    QWORD PTR [rsp+0x88],0xffffffffc00145e0
ffffffffc0015bfd:	00 e0 45 01 c0 
ffffffffc0015c02:	48 89 8c 24 90 00 00 	mov    QWORD PTR [rsp+0x90],rcx
ffffffffc0015c09:	00 
ffffffffc0015c0a:	48 c7 84 24 98 00 00 	mov    QWORD PTR [rsp+0x98],0xffffffffc00145e0
ffffffffc0015c11:	00 e0 45 01 c0 
ffffffffc0015c16:	e8 e5 ea ff ff       	call   ffffffffc0014700 <_ZN4core9panicking9panic_fmt17hdd83f09e27d90e4dE>
ffffffffc0015c1b:	0f 0b                	ud2    
ffffffffc0015c1d:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015c22:	48 c7 c7 f0 8b 01 c0 	mov    rdi,0xffffffffc0018bf0
ffffffffc0015c29:	48 c7 c2 f0 8d 01 c0 	mov    rdx,0xffffffffc0018df0
ffffffffc0015c30:	e8 fb e9 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015c35:	0f 0b                	ud2    
ffffffffc0015c37:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0015c3c:	48 c7 c7 d0 8b 01 c0 	mov    rdi,0xffffffffc0018bd0
ffffffffc0015c43:	48 c7 c2 30 90 01 c0 	mov    rdx,0xffffffffc0019030
ffffffffc0015c4a:	e8 e1 e9 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015c4f:	0f 0b                	ud2    
ffffffffc0015c51:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0015c56:	48 c7 c7 d0 8b 01 c0 	mov    rdi,0xffffffffc0018bd0
ffffffffc0015c5d:	48 c7 c2 10 91 01 c0 	mov    rdx,0xffffffffc0019110
ffffffffc0015c64:	e8 c7 e9 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015c69:	0f 0b                	ud2    
ffffffffc0015c6b:	cc                   	int3   
ffffffffc0015c6c:	cc                   	int3   
ffffffffc0015c6d:	cc                   	int3   
ffffffffc0015c6e:	cc                   	int3   
ffffffffc0015c6f:	cc                   	int3   

ffffffffc0015c70 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE>:
ffffffffc0015c70:	48 83 ec 08          	sub    rsp,0x8
ffffffffc0015c74:	41 89 f8             	mov    r8d,edi
ffffffffc0015c77:	b8 20 00 00 00       	mov    eax,0x20
ffffffffc0015c7c:	31 c9                	xor    ecx,ecx
ffffffffc0015c7e:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0015c83:	41 c1 e0 0b          	shl    r8d,0xb
ffffffffc0015c87:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0015c8e:	00 00 
ffffffffc0015c90:	48 d1 e8             	shr    rax,1
ffffffffc0015c93:	48 01 c8             	add    rax,rcx
ffffffffc0015c96:	0f 82 2e 01 00 00    	jb     ffffffffc0015dca <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x15a>
ffffffffc0015c9c:	48 83 f8 20          	cmp    rax,0x20
ffffffffc0015ca0:	0f 83 fb 01 00 00    	jae    ffffffffc0015ea1 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x231>
ffffffffc0015ca6:	8b 14 85 68 92 01 c0 	mov    edx,DWORD PTR [rax*4-0x3ffe6d98]
ffffffffc0015cad:	c1 e2 0b             	shl    edx,0xb
ffffffffc0015cb0:	44 39 c2             	cmp    edx,r8d
ffffffffc0015cb3:	73 0b                	jae    ffffffffc0015cc0 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x50>
ffffffffc0015cb5:	48 ff c0             	inc    rax
ffffffffc0015cb8:	48 89 c1             	mov    rcx,rax
ffffffffc0015cbb:	48 89 f0             	mov    rax,rsi
ffffffffc0015cbe:	eb 09                	jmp    ffffffffc0015cc9 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x59>
ffffffffc0015cc0:	48 89 c6             	mov    rsi,rax
ffffffffc0015cc3:	0f 84 d4 00 00 00    	je     ffffffffc0015d9d <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x12d>
ffffffffc0015cc9:	48 29 c8             	sub    rax,rcx
ffffffffc0015ccc:	0f 82 12 01 00 00    	jb     ffffffffc0015de4 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x174>
ffffffffc0015cd2:	77 bc                	ja     ffffffffc0015c90 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x20>
ffffffffc0015cd4:	48 83 f9 1f          	cmp    rcx,0x1f
ffffffffc0015cd8:	0f 87 cf 00 00 00    	ja     ffffffffc0015dad <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x13d>
ffffffffc0015cde:	8b 04 8d 68 92 01 c0 	mov    eax,DWORD PTR [rcx*4-0x3ffe6d98]
ffffffffc0015ce5:	48 c1 e8 15          	shr    rax,0x15
ffffffffc0015ce9:	48 83 f9 1f          	cmp    rcx,0x1f
ffffffffc0015ced:	75 24                	jne    ffffffffc0015d13 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0xa3>
ffffffffc0015cef:	ba c3 02 00 00       	mov    edx,0x2c3
ffffffffc0015cf4:	48 29 c2             	sub    rdx,rax
ffffffffc0015cf7:	73 2e                	jae    ffffffffc0015d27 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0xb7>
ffffffffc0015cf9:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015cfe:	48 c7 c7 f0 8b 01 c0 	mov    rdi,0xffffffffc0018bf0
ffffffffc0015d05:	48 c7 c2 c0 91 01 c0 	mov    rdx,0xffffffffc00191c0
ffffffffc0015d0c:	e8 1f e9 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015d11:	0f 0b                	ud2    
ffffffffc0015d13:	8b 14 8d 6c 92 01 c0 	mov    edx,DWORD PTR [rcx*4-0x3ffe6d94]
ffffffffc0015d1a:	48 c1 ea 15          	shr    rdx,0x15
ffffffffc0015d1e:	48 29 c2             	sub    rdx,rax
ffffffffc0015d21:	0f 82 4a 01 00 00    	jb     ffffffffc0015e71 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x201>
ffffffffc0015d27:	31 f6                	xor    esi,esi
ffffffffc0015d29:	48 83 e9 01          	sub    rcx,0x1
ffffffffc0015d2d:	72 16                	jb     ffffffffc0015d45 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0xd5>
ffffffffc0015d2f:	48 83 f9 20          	cmp    rcx,0x20
ffffffffc0015d33:	0f 83 52 01 00 00    	jae    ffffffffc0015e8b <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x21b>
ffffffffc0015d39:	be ff ff 1f 00       	mov    esi,0x1fffff
ffffffffc0015d3e:	23 34 8d 68 92 01 c0 	and    esi,DWORD PTR [rcx*4-0x3ffe6d98]
ffffffffc0015d45:	29 f7                	sub    edi,esi
ffffffffc0015d47:	0f 82 f0 00 00 00    	jb     ffffffffc0015e3d <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x1cd>
ffffffffc0015d4d:	49 89 d1             	mov    r9,rdx
ffffffffc0015d50:	49 83 e9 01          	sub    r9,0x1
ffffffffc0015d54:	0f 82 fd 00 00 00    	jb     ffffffffc0015e57 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x1e7>
ffffffffc0015d5a:	74 6a                	je     ffffffffc0015dc6 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x156>
ffffffffc0015d5c:	4c 8d 44 10 ff       	lea    r8,[rax+rdx*1-0x1]
ffffffffc0015d61:	31 f6                	xor    esi,esi
ffffffffc0015d63:	48 89 c2             	mov    rdx,rax
ffffffffc0015d66:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
ffffffffc0015d6d:	00 00 00 
ffffffffc0015d70:	48 81 fa c2 02 00 00 	cmp    rdx,0x2c2
ffffffffc0015d77:	0f 87 81 00 00 00    	ja     ffffffffc0015dfe <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x18e>
ffffffffc0015d7d:	0f b6 8a e8 92 01 c0 	movzx  ecx,BYTE PTR [rdx-0x3ffe6d18]
ffffffffc0015d84:	01 ce                	add    esi,ecx
ffffffffc0015d86:	0f 82 97 00 00 00    	jb     ffffffffc0015e23 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x1b3>
ffffffffc0015d8c:	39 fe                	cmp    esi,edi
ffffffffc0015d8e:	77 33                	ja     ffffffffc0015dc3 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x153>
ffffffffc0015d90:	48 ff c2             	inc    rdx
ffffffffc0015d93:	49 ff c9             	dec    r9
ffffffffc0015d96:	75 d8                	jne    ffffffffc0015d70 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x100>
ffffffffc0015d98:	4c 89 c0             	mov    rax,r8
ffffffffc0015d9b:	eb 29                	jmp    ffffffffc0015dc6 <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x156>
ffffffffc0015d9d:	48 ff c0             	inc    rax
ffffffffc0015da0:	48 89 c1             	mov    rcx,rax
ffffffffc0015da3:	48 83 f9 1f          	cmp    rcx,0x1f
ffffffffc0015da7:	0f 86 31 ff ff ff    	jbe    ffffffffc0015cde <_ZN4core7unicode12unicode_data15grapheme_extend6lookup17h4d0a8c86a00e30daE+0x6e>
ffffffffc0015dad:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0015db2:	48 89 cf             	mov    rdi,rcx
ffffffffc0015db5:	48 c7 c2 a8 91 01 c0 	mov    rdx,0xffffffffc00191a8
ffffffffc0015dbc:	e8 bf e8 ff ff       	call   ffffffffc0014680 <_ZN4core9panicking18panic_bounds_check17hfb23d00fc1893b91E>
ffffffffc0015dc1:	0f 0b                	ud2    
ffffffffc0015dc3:	48 89 d0             	mov    rax,rdx
ffffffffc0015dc6:	24 01                	and    al,0x1
ffffffffc0015dc8:	59                   	pop    rcx
ffffffffc0015dc9:	c3                   	ret    
ffffffffc0015dca:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0015dcf:	48 c7 c7 d0 8b 01 c0 	mov    rdi,0xffffffffc0018bd0
ffffffffc0015dd6:	48 c7 c2 48 8d 01 c0 	mov    rdx,0xffffffffc0018d48
ffffffffc0015ddd:	e8 4e e8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015de2:	0f 0b                	ud2    
ffffffffc0015de4:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015de9:	48 c7 c7 f0 8b 01 c0 	mov    rdi,0xffffffffc0018bf0
ffffffffc0015df0:	48 c7 c2 60 8d 01 c0 	mov    rdx,0xffffffffc0018d60
ffffffffc0015df7:	e8 34 e8 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015dfc:	0f 0b                	ud2    
ffffffffc0015dfe:	48 3d c4 02 00 00    	cmp    rax,0x2c4
ffffffffc0015e04:	b9 c3 02 00 00       	mov    ecx,0x2c3
ffffffffc0015e09:	be c3 02 00 00       	mov    esi,0x2c3
ffffffffc0015e0e:	48 c7 c2 20 92 01 c0 	mov    rdx,0xffffffffc0019220
ffffffffc0015e15:	48 0f 42 c1          	cmovb  rax,rcx
ffffffffc0015e19:	48 89 c7             	mov    rdi,rax
ffffffffc0015e1c:	e8 5f e8 ff ff       	call   ffffffffc0014680 <_ZN4core9panicking18panic_bounds_check17hfb23d00fc1893b91E>
ffffffffc0015e21:	0f 0b                	ud2    
ffffffffc0015e23:	be 1c 00 00 00       	mov    esi,0x1c
ffffffffc0015e28:	48 c7 c7 d0 8b 01 c0 	mov    rdi,0xffffffffc0018bd0
ffffffffc0015e2f:	48 c7 c2 38 92 01 c0 	mov    rdx,0xffffffffc0019238
ffffffffc0015e36:	e8 f5 e7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015e3b:	0f 0b                	ud2    
ffffffffc0015e3d:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015e42:	48 c7 c7 f0 8b 01 c0 	mov    rdi,0xffffffffc0018bf0
ffffffffc0015e49:	48 c7 c2 f0 91 01 c0 	mov    rdx,0xffffffffc00191f0
ffffffffc0015e50:	e8 db e7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015e55:	0f 0b                	ud2    
ffffffffc0015e57:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015e5c:	48 c7 c7 f0 8b 01 c0 	mov    rdi,0xffffffffc0018bf0
ffffffffc0015e63:	48 c7 c2 08 92 01 c0 	mov    rdx,0xffffffffc0019208
ffffffffc0015e6a:	e8 c1 e7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015e6f:	0f 0b                	ud2    
ffffffffc0015e71:	be 21 00 00 00       	mov    esi,0x21
ffffffffc0015e76:	48 c7 c7 f0 8b 01 c0 	mov    rdi,0xffffffffc0018bf0
ffffffffc0015e7d:	48 c7 c2 d8 91 01 c0 	mov    rdx,0xffffffffc00191d8
ffffffffc0015e84:	e8 a7 e7 ff ff       	call   ffffffffc0014630 <_ZN4core9panicking5panic17he609179208c74250E>
ffffffffc0015e89:	0f 0b                	ud2    
ffffffffc0015e8b:	be 20 00 00 00       	mov    esi,0x20
ffffffffc0015e90:	48 89 cf             	mov    rdi,rcx
ffffffffc0015e93:	48 c7 c2 50 92 01 c0 	mov    rdx,0xffffffffc0019250
ffffffffc0015e9a:	e8 e1 e7 ff ff       	call   ffffffffc0014680 <_ZN4core9panicking18panic_bounds_check17hfb23d00fc1893b91E>
ffffffffc0015e9f:	0f 0b                	ud2    
ffffffffc0015ea1:	0f 0b                	ud2    
ffffffffc0015ea3:	0f 0b                	ud2    
ffffffffc0015ea5:	cc                   	int3   
ffffffffc0015ea6:	cc                   	int3   
ffffffffc0015ea7:	cc                   	int3   
ffffffffc0015ea8:	cc                   	int3   
ffffffffc0015ea9:	cc                   	int3   
ffffffffc0015eaa:	cc                   	int3   
ffffffffc0015eab:	cc                   	int3   
ffffffffc0015eac:	cc                   	int3   
ffffffffc0015ead:	cc                   	int3   
ffffffffc0015eae:	cc                   	int3   
ffffffffc0015eaf:	cc                   	int3   

ffffffffc0015eb0 <memset>:
ffffffffc0015eb0:	e9 0b 00 00 00       	jmp    ffffffffc0015ec0 <_ZN17compiler_builtins3mem6memset17h97b6ffb8bf166be9E>
ffffffffc0015eb5:	cc                   	int3   
ffffffffc0015eb6:	cc                   	int3   
ffffffffc0015eb7:	cc                   	int3   
ffffffffc0015eb8:	cc                   	int3   
ffffffffc0015eb9:	cc                   	int3   
ffffffffc0015eba:	cc                   	int3   
ffffffffc0015ebb:	cc                   	int3   
ffffffffc0015ebc:	cc                   	int3   
ffffffffc0015ebd:	cc                   	int3   
ffffffffc0015ebe:	cc                   	int3   
ffffffffc0015ebf:	cc                   	int3   

ffffffffc0015ec0 <_ZN17compiler_builtins3mem6memset17h97b6ffb8bf166be9E>:
ffffffffc0015ec0:	48 89 d1             	mov    rcx,rdx
ffffffffc0015ec3:	40 0f b6 f6          	movzx  esi,sil
ffffffffc0015ec7:	48 b8 01 01 01 01 01 	movabs rax,0x101010101010101
ffffffffc0015ece:	01 01 01 
ffffffffc0015ed1:	48 89 fa             	mov    rdx,rdi
ffffffffc0015ed4:	48 0f af c6          	imul   rax,rsi
ffffffffc0015ed8:	89 ce                	mov    esi,ecx
ffffffffc0015eda:	48 c1 e9 03          	shr    rcx,0x3
ffffffffc0015ede:	83 e6 07             	and    esi,0x7
ffffffffc0015ee1:	f3 48 ab             	rep stos QWORD PTR es:[rdi],rax
ffffffffc0015ee4:	89 f1                	mov    ecx,esi
ffffffffc0015ee6:	f3 aa                	rep stos BYTE PTR es:[rdi],al
ffffffffc0015ee8:	48 89 d0             	mov    rax,rdx
ffffffffc0015eeb:	c3                   	ret    
ffffffffc0015eec:	cc                   	int3   
ffffffffc0015eed:	cc                   	int3   
ffffffffc0015eee:	cc                   	int3   
ffffffffc0015eef:	cc                   	int3   

ffffffffc0015ef0 <str.0>:
ffffffffc0015ef0:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0015f00:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....
ffffffffc0015f10:	63 61 6c 6c 65 64 20 60 4f 70 74 69 6f 6e 3a 3a     called `Option::
ffffffffc0015f20:	75 6e 77 72 61 70 28 29 60 20 6f 6e 20 61 20 60     unwrap()` on a `
ffffffffc0015f30:	4e 6f 6e 65 60 20 76 61 6c 75 65 61 64 64 72 20     None` valueaddr 
ffffffffc0015f40:	69 73 20 6e 6f 74 20 70 61 67 65 2d 61 6c 69 67     is not page-alig
ffffffffc0015f50:	6e 65 64 20 6f 72 20 69 73 20 74 6f 6f 20 6c 61     ned or is too la
ffffffffc0015f60:	72 67 65 20 66 6f 72 20 41 4d 44 36 34 20 61 72     rge for AMD64 ar
ffffffffc0015f70:	63 68 69 74 65 63 74 75 72 65 cc cc cc cc cc cc     chitecture......
ffffffffc0015f80:	3b 5f 01 c0 ff ff ff ff 3f 00 00 00 00 00 00 00     ;_......?.......
ffffffffc0015f90:	2f 6d 6e 74 2f 64 2f 73 72 63 2f 72 75 73 74 2f     /mnt/d/src/rust/
ffffffffc0015fa0:	74 61 75 6f 73 2f 61 6d 64 36 34 2f 73 72 63 2f     tauos/amd64/src/
ffffffffc0015fb0:	70 61 67 69 6e 67 2e 72 73 cc cc cc cc cc cc cc     paging.rs.......
ffffffffc0015fc0:	90 5f 01 c0 ff ff ff ff 29 00 00 00 00 00 00 00     ._......).......
ffffffffc0015fd0:	86 00 00 00 09 00 00 00 2f 6d 6e 74 2f 64 2f 73     ......../mnt/d/s
ffffffffc0015fe0:	72 63 2f 72 75 73 74 2f 74 61 75 6f 73 2f 6b 65     rc/rust/tauos/ke
ffffffffc0015ff0:	72 6e 65 6c 2f 73 72 63 2f 6d 65 6d 6d 2f 6d 6f     rnel/src/memm/mo
ffffffffc0016000:	64 2e 72 73 cc cc cc cc d8 5f 01 c0 ff ff ff ff     d.rs....._......
ffffffffc0016010:	2c 00 00 00 00 00 00 00 2c 01 00 00 43 00 00 00     ,.......,...C...
ffffffffc0016020:	d8 5f 01 c0 ff ff ff ff 2c 00 00 00 00 00 00 00     ._......,.......
ffffffffc0016030:	2d 01 00 00 39 00 00 00 d8 5f 01 c0 ff ff ff ff     -...9...._......
ffffffffc0016040:	2c 00 00 00 00 00 00 00 2f 01 00 00 26 00 00 00     ,......./...&...

ffffffffc0016050 <str.2>:
ffffffffc0016050:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc0016060:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0016070:	77 cc cc cc cc cc cc cc d8 5f 01 c0 ff ff ff ff     w........_......
ffffffffc0016080:	2c 00 00 00 00 00 00 00 6c 01 00 00 15 00 00 00     ,.......l.......

ffffffffc0016090 <str.3>:
ffffffffc0016090:	61 74 74 65 6d 70 74 20 74 6f 20 6d 75 6c 74 69     attempt to multi
ffffffffc00160a0:	70 6c 79 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     ply with overflo
ffffffffc00160b0:	77 cc cc cc cc cc cc cc d8 5f 01 c0 ff ff ff ff     w........_......
ffffffffc00160c0:	2c 00 00 00 00 00 00 00 83 01 00 00 21 00 00 00     ,...........!...
ffffffffc00160d0:	d8 5f 01 c0 ff ff ff ff 2c 00 00 00 00 00 00 00     ._......,.......
ffffffffc00160e0:	84 01 00 00 1c 00 00 00 d8 5f 01 c0 ff ff ff ff     ........._......
ffffffffc00160f0:	2c 00 00 00 00 00 00 00 86 01 00 00 1f 00 00 00     ,...............
ffffffffc0016100:	d8 5f 01 c0 ff ff ff ff 2c 00 00 00 00 00 00 00     ._......,.......
ffffffffc0016110:	86 01 00 00 09 00 00 00 d8 5f 01 c0 ff ff ff ff     ........._......
ffffffffc0016120:	2c 00 00 00 00 00 00 00 98 01 00 00 25 00 00 00     ,...........%...
ffffffffc0016130:	d8 5f 01 c0 ff ff ff ff 2c 00 00 00 00 00 00 00     ._......,.......
ffffffffc0016140:	99 01 00 00 18 00 00 00 d8 5f 01 c0 ff ff ff ff     ........._......
ffffffffc0016150:	2c 00 00 00 00 00 00 00 32 01 00 00 0d 00 00 00     ,.......2.......
ffffffffc0016160:	d8 5f 01 c0 ff ff ff ff 2c 00 00 00 00 00 00 00     ._......,.......
ffffffffc0016170:	33 01 00 00 0d 00 00 00 d8 5f 01 c0 ff ff ff ff     3........_......
ffffffffc0016180:	2c 00 00 00 00 00 00 00 2c 01 00 00 38 00 00 00     ,.......,...8...
ffffffffc0016190:	61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65 64     assertion failed
ffffffffc00161a0:	3a 20 73 69 7a 65 20 3e 3d 20 73 65 6c 66 2e 73     : size >= self.s
ffffffffc00161b0:	6d 6c 73 74 5f 62 6c 6f 63 6b 2f 6d 6e 74 2f 64     mlst_block/mnt/d
ffffffffc00161c0:	2f 73 72 63 2f 72 75 73 74 2f 74 61 75 6f 73 2f     /src/rust/tauos/
ffffffffc00161d0:	6b 65 72 6e 65 6c 2f 73 72 63 2f 6d 65 6d 6d 2f     kernel/src/memm/
ffffffffc00161e0:	74 61 6c 6c 6f 63 2e 72 73 cc cc cc cc cc cc cc     talloc.rs.......
ffffffffc00161f0:	ba 61 01 c0 ff ff ff ff 2f 00 00 00 00 00 00 00     .a....../.......
ffffffffc0016200:	5c 01 00 00 09 00 00 00 ba 61 01 c0 ff ff ff ff     \........a......
ffffffffc0016210:	2f 00 00 00 00 00 00 00 5d 01 00 00 14 00 00 00     /.......].......
ffffffffc0016220:	ba 61 01 c0 ff ff ff ff 2f 00 00 00 00 00 00 00     .a....../.......
ffffffffc0016230:	5f 01 00 00 0a 00 00 00 ba 61 01 c0 ff ff ff ff     _........a......
ffffffffc0016240:	2f 00 00 00 00 00 00 00 60 01 00 00 0a 00 00 00     /.......`.......

ffffffffc0016250 <str.0>:
ffffffffc0016250:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0016260:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....
ffffffffc0016270:	0a cc cc cc cc cc cc cc 70 62 01 c0 ff ff ff ff     ........pb......
ffffffffc0016280:	01 00 00 00 00 00 00 00 5b 42 53 50 5d 20 4b 45     ........[BSP] KE
ffffffffc0016290:	52 4e 45 4c 20 49 4e 49 54 21 cc cc cc cc cc cc     RNEL INIT!......
ffffffffc00162a0:	88 62 01 c0 ff ff ff ff 12 00 00 00 00 00 00 00     .b..............
ffffffffc00162b0:	6b 65 72 6e 65 6c 2f 73 72 63 2f 69 6e 69 74 2e     kernel/src/init.
ffffffffc00162c0:	72 73 cc cc cc cc cc cc b0 62 01 c0 ff ff ff ff     rs.......b......
ffffffffc00162d0:	12 00 00 00 00 00 00 00 20 00 00 00 1d 00 00 00     ........ .......

ffffffffc00162e0 <str.1>:
ffffffffc00162e0:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc00162f0:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0016300:	77 4d 41 50 50 45 52 20 49 4e 49 54 44 cc cc cc     wMAPPER INITD...
ffffffffc0016310:	01 63 01 c0 ff ff ff ff 0c 00 00 00 00 00 00 00     .c..............
ffffffffc0016320:	b0 62 01 c0 ff ff ff ff 12 00 00 00 00 00 00 00     .b..............
ffffffffc0016330:	3b 00 00 00 2e 00 00 00 cc cc cc cc cc cc cc cc     ;...............

ffffffffc0016340 <str.3>:
ffffffffc0016340:	61 74 74 65 6d 70 74 20 74 6f 20 6d 75 6c 74 69     attempt to multi
ffffffffc0016350:	70 6c 79 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     ply with overflo
ffffffffc0016360:	77 cc cc cc cc cc cc cc b0 62 01 c0 ff ff ff ff     w........b......
ffffffffc0016370:	12 00 00 00 00 00 00 00 3b 00 00 00 16 00 00 00     ........;.......
ffffffffc0016380:	54 3a 20 6d 61 70 70 69 6e 20 73 74 61 63 6b cc     T: mappin stack.
ffffffffc0016390:	80 63 01 c0 ff ff ff ff 01 00 00 00 00 00 00 00     .c..............
ffffffffc00163a0:	81 63 01 c0 ff ff ff ff 0e 00 00 00 00 00 00 00     .c..............
ffffffffc00163b0:	b0 62 01 c0 ff ff ff ff 12 00 00 00 00 00 00 00     .b..............
ffffffffc00163c0:	41 00 00 00 0d 00 00 00 b0 62 01 c0 ff ff ff ff     A........b......
ffffffffc00163d0:	12 00 00 00 00 00 00 00 46 00 00 00 11 00 00 00     ........F.......
ffffffffc00163e0:	3a 20 6d 61 70 70 64 20 73 74 61 63 6b cc cc cc     : mappd stack...
ffffffffc00163f0:	80 63 01 c0 ff ff ff ff 01 00 00 00 00 00 00 00     .c..............
ffffffffc0016400:	e0 63 01 c0 ff ff ff ff 0d 00 00 00 00 00 00 00     .c..............
ffffffffc0016410:	3a 20 5f 73 74 61 72 74 20 2d 3e 20 69 6e 69 74     : _start -> init
ffffffffc0016420:	29 20 77 68 65 6e 20 73 6c 69 63 69 6e 67 20 60     ) when slicing `

ffffffffc0016430 <anon.dd2818591b42213fe1fcfb0fc14b1510.53.llvm.17494642119417435983>:
ffffffffc0016430:	72 61 6e 67 65 20 65 6e 64 20 69 6e 64 65 78 20     range end index 
ffffffffc0016440:	80 63 01 c0 ff ff ff ff 01 00 00 00 00 00 00 00     .c..............
ffffffffc0016450:	10 64 01 c0 ff ff ff ff 10 00 00 00 00 00 00 00     .d..............
ffffffffc0016460:	70 62 01 c0 ff ff ff ff 00 00 00 00 00 00 00 00     pb..............

ffffffffc0016470 <str.0.llvm.11767564005678988311>:
ffffffffc0016470:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0016480:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....
ffffffffc0016490:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc00164a0:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc00164b0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc00164c0:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc00164d0:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc00164e0:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc00164f0:	65 2f 73 72 63 2f 6e 75 6d 2f 6d 6f 64 2e 72 73     e/src/num/mod.rs
ffffffffc0016500:	90 64 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     .d......p.......
ffffffffc0016510:	75 03 00 00 05 00 00 00 cc cc cc cc cc cc cc cc     u...............

ffffffffc0016520 <str.1.llvm.11767564005678988311>:
ffffffffc0016520:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc0016530:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0016540:	77 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc     w...............

ffffffffc0016550 <str.2.llvm.11767564005678988311>:
ffffffffc0016550:	61 74 74 65 6d 70 74 20 74 6f 20 73 68 69 66 74     attempt to shift
ffffffffc0016560:	20 72 69 67 68 74 20 77 69 74 68 20 6f 76 65 72      right with over
ffffffffc0016570:	66 6c 6f 77                                         flow

ffffffffc0016574 <anon.9e06a6e1140bb8e5b8e55c7a8ce9ddb1.3.llvm.11767564005678988311>:
ffffffffc0016574:	6b 65 72 6e 65 6c 2f 73 72 63 2f 6d 65 6d 6d 2f     kernel/src/memm/
ffffffffc0016584:	74 61 6c 6c 6f 63 2e 72 73 cc cc cc                 talloc.rs...

ffffffffc0016590 <anon.9e06a6e1140bb8e5b8e55c7a8ce9ddb1.4.llvm.11767564005678988311>:
ffffffffc0016590:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc00165a0:	5d 00 00 00 09 00 00 00 74 65 01 c0 ff ff ff ff     ].......te......
ffffffffc00165b0:	19 00 00 00 00 00 00 00 6b 00 00 00 32 00 00 00     ........k...2...

ffffffffc00165c0 <anon.9e06a6e1140bb8e5b8e55c7a8ce9ddb1.6.llvm.11767564005678988311>:
ffffffffc00165c0:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc00165d0:	6b 00 00 00 0d 00 00 00                             k.......

ffffffffc00165d8 <anon.9e06a6e1140bb8e5b8e55c7a8ce9ddb1.7.llvm.11767564005678988311>:
ffffffffc00165d8:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc00165e8:	69 00 00 00 09 00 00 00                             i.......

ffffffffc00165f0 <str.3.llvm.11767564005678988311>:
ffffffffc00165f0:	61 74 74 65 6d 70 74 20 74 6f 20 73 68 69 66 74     attempt to shift
ffffffffc0016600:	20 6c 65 66 74 20 77 69 74 68 20 6f 76 65 72 66      left with overf
ffffffffc0016610:	6c 6f 77 cc cc cc cc cc 74 65 01 c0 ff ff ff ff     low.....te......
ffffffffc0016620:	19 00 00 00 00 00 00 00 89 00 00 00 18 00 00 00     ................
ffffffffc0016630:	6f 6f 6f 61 20 cc cc cc 30 66 01 c0 ff ff ff ff     oooa ...0f......
ffffffffc0016640:	05 00 00 00 00 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016650:	19 00 00 00 00 00 00 00 93 00 00 00 0d 00 00 00     ................
ffffffffc0016660:	6f 6f 6f cc cc cc cc cc 60 66 01 c0 ff ff ff ff     ooo.....`f......
ffffffffc0016670:	03 00 00 00 00 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016680:	19 00 00 00 00 00 00 00 8f 00 00 00 0d 00 00 00     ................
ffffffffc0016690:	0a cc cc cc cc cc cc cc 90 66 01 c0 ff ff ff ff     .........f......
ffffffffc00166a0:	01 00 00 00 00 00 00 00 20 3c 3d 20 6e 61 6e 69     ........ <= nani
ffffffffc00166b0:	73 65 3a 20 cc cc cc cc b0 66 01 c0 ff ff ff ff     se: .....f......
ffffffffc00166c0:	04 00 00 00 00 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc00166d0:	19 00 00 00 00 00 00 00 a7 00 00 00 1d 00 00 00     ................
ffffffffc00166e0:	6e 6f 20 20 6e 20 cc cc e0 66 01 c0 ff ff ff ff     no  n ...f......
ffffffffc00166f0:	03 00 00 00 00 00 00 00 e3 66 01 c0 ff ff ff ff     .........f......
ffffffffc0016700:	03 00 00 00 00 00 00 00 ac 66 01 c0 ff ff ff ff     .........f......
ffffffffc0016710:	04 00 00 00 00 00 00 00 6f 6b 3f cc cc cc cc cc     ........ok?.....
ffffffffc0016720:	18 67 01 c0 ff ff ff ff 03 00 00 00 00 00 00 00     .g..............
ffffffffc0016730:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016740:	cd 00 00 00 1d 00 00 00 61 72 65 6e 61 5f 73 69     ........arena_si
ffffffffc0016750:	7a 65 20 6d 75 73 74 20 62 65 20 3e 20 7a 65 72     ze must be > zer
ffffffffc0016760:	6f 2e cc cc cc cc cc cc 48 67 01 c0 ff ff ff ff     o.......Hg......
ffffffffc0016770:	1a 00 00 00 00 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016780:	19 00 00 00 00 00 00 00 fd 00 00 00 09 00 00 00     ................
ffffffffc0016790:	61 72 65 6e 61 5f 73 69 7a 65 20 6d 75 73 74 20     arena_size must 
ffffffffc00167a0:	62 65 20 3c 3d 20 74 61 6c 6c 6f 63 3a 3a 4d 41     be <= talloc::MA
ffffffffc00167b0:	58 49 4d 55 4d 5f 41 52 45 4e 41 5f 53 49 5a 45     XIMUM_ARENA_SIZE
ffffffffc00167c0:	2e cc cc cc cc cc cc cc 90 67 01 c0 ff ff ff ff     .........g......
ffffffffc00167d0:	31 00 00 00 00 00 00 00 74 65 01 c0 ff ff ff ff     1.......te......
ffffffffc00167e0:	19 00 00 00 00 00 00 00 ff 00 00 00 09 00 00 00     ................
ffffffffc00167f0:	73 6d 61 6c 6c 65 73 74 5f 62 6c 6f 63 6b 20 6d     smallest_block m
ffffffffc0016800:	75 73 74 20 62 65 20 3e 20 7a 65 72 6f 2e cc cc     ust be > zero...
ffffffffc0016810:	f0 67 01 c0 ff ff ff ff 1e 00 00 00 00 00 00 00     .g..............
ffffffffc0016820:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016830:	01 01 00 00 09 00 00 00 73 6d 61 6c 6c 65 73 74     ........smallest
ffffffffc0016840:	5f 62 6c 6f 63 6b 20 6d 75 73 74 20 62 65 20 61     _block must be a
ffffffffc0016850:	20 70 6f 77 65 72 20 6f 66 20 74 77 6f 2e cc cc      power of two...
ffffffffc0016860:	38 68 01 c0 ff ff ff ff 26 00 00 00 00 00 00 00     8h......&.......
ffffffffc0016870:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016880:	03 01 00 00 09 00 00 00 73 6d 61 6c 6c 65 73 74     ........smallest
ffffffffc0016890:	5f 62 6c 6f 63 6b 20 6d 75 73 74 20 62 65 20 67     _block must be g
ffffffffc00168a0:	72 65 61 74 65 72 20 6f 72 20 65 71 75 61 6c 20     reater or equal 
ffffffffc00168b0:	74 68 65 20 73 69 7a 65 20 6f 66 20 74 77 6f 20     the size of two 
ffffffffc00168c0:	70 6f 69 6e 74 65 72 73 2e cc cc cc cc cc cc cc     pointers........
ffffffffc00168d0:	88 68 01 c0 ff ff ff ff 41 00 00 00 00 00 00 00     .h......A.......
ffffffffc00168e0:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc00168f0:	07 01 00 00 09 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016900:	19 00 00 00 00 00 00 00 11 01 00 00 1b 00 00 00     ................
ffffffffc0016910:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016920:	11 01 00 00 2c 00 00 00 74 65 01 c0 ff ff ff ff     ....,...te......
ffffffffc0016930:	19 00 00 00 00 00 00 00 11 01 00 00 1a 00 00 00     ................
ffffffffc0016940:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016950:	11 01 00 00 49 00 00 00 74 65 01 c0 ff ff ff ff     ....I...te......
ffffffffc0016960:	19 00 00 00 00 00 00 00 12 01 00 00 1a 00 00 00     ................
ffffffffc0016970:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016980:	24 01 00 00 0d 00 00 00 74 65 01 c0 ff ff ff ff     $.......te......
ffffffffc0016990:	19 00 00 00 00 00 00 00 25 01 00 00 0d 00 00 00     ........%.......
ffffffffc00169a0:	61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65 64     assertion failed
ffffffffc00169b0:	3a 20 73 70 61 6e 2e 73 74 61 72 74 20 21 3d 20     : span.start != 
ffffffffc00169c0:	73 70 61 6e 2e 65 6e 64 61 73 73 65 72 74 69 6f     span.endassertio
ffffffffc00169d0:	6e 20 66 61 69 6c 65 64 3a 20 73 70 61 6e 2e 73     n failed: span.s
ffffffffc00169e0:	74 61 72 74 20 3e 3d 20 73 65 6c 66 2e 61 72 65     tart >= self.are
ffffffffc00169f0:	6e 61 5f 62 61 73 65 61 73 73 65 72 74 69 6f 6e     na_baseassertion
ffffffffc0016a00:	20 66 61 69 6c 65 64 3a 20 73 70 61 6e 2e 65 6e      failed: span.en
ffffffffc0016a10:	64 20 3c 3d 20 28 73 65 6c 66 2e 61 72 65 6e 61     d <= (self.arena
ffffffffc0016a20:	5f 62 61 73 65 20 2b 20 73 65 6c 66 2e 61 72 65     _base + self.are
ffffffffc0016a30:	6e 61 5f 73 69 7a 65 20 61 73 20 69 73 69 7a 65     na_size as isize
ffffffffc0016a40:	29 61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65     )assertion faile
ffffffffc0016a50:	64 3a 20 73 70 61 6e 2e 73 74 61 72 74 20 61 73     d: span.start as
ffffffffc0016a60:	20 75 73 69 7a 65 20 26 20 73 65 6c 66 2e 73 6d      usize & self.sm
ffffffffc0016a70:	6c 73 74 5f 62 6c 6f 63 6b 20 2d 20 31 20 3d 3d     lst_block - 1 ==
ffffffffc0016a80:	20 30 61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c      0assertion fail
ffffffffc0016a90:	65 64 3a 20 73 70 61 6e 2e 65 6e 64 20 61 73 20     ed: span.end as 
ffffffffc0016aa0:	75 73 69 7a 65 20 26 20 73 65 6c 66 2e 73 6d 6c     usize & self.sml
ffffffffc0016ab0:	73 74 5f 62 6c 6f 63 6b 20 2d 20 31 20 3d 3d 20     st_block - 1 == 
ffffffffc0016ac0:	30 cc cc cc cc cc cc cc 74 65 01 c0 ff ff ff ff     0.......te......
ffffffffc0016ad0:	19 00 00 00 00 00 00 00 ee 01 00 00 09 00 00 00     ................
ffffffffc0016ae0:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016af0:	ef 01 00 00 09 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016b00:	19 00 00 00 00 00 00 00 f0 01 00 00 23 00 00 00     ............#...
ffffffffc0016b10:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016b20:	f0 01 00 00 09 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016b30:	19 00 00 00 00 00 00 00 f1 01 00 00 2d 00 00 00     ............-...
ffffffffc0016b40:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016b50:	f1 01 00 00 09 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016b60:	19 00 00 00 00 00 00 00 f2 01 00 00 09 00 00 00     ................
ffffffffc0016b70:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016b80:	f8 01 00 00 22 00 00 00 74 65 01 c0 ff ff ff ff     ...."...te......
ffffffffc0016b90:	19 00 00 00 00 00 00 00 fa 01 00 00 14 00 00 00     ................
ffffffffc0016ba0:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016bb0:	01 02 00 00 1d 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016bc0:	19 00 00 00 00 00 00 00 0d 02 00 00 0d 00 00 00     ................

ffffffffc0016bd0 <anon.9e06a6e1140bb8e5b8e55c7a8ce9ddb1.82.llvm.11767564005678988311>:
ffffffffc0016bd0:	74 65 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     te..............
ffffffffc0016be0:	28 02 00 00 1a 00 00 00 74 65 01 c0 ff ff ff ff     (.......te......
ffffffffc0016bf0:	19 00 00 00 00 00 00 00 6a 02 00 00 0d 00 00 00     ........j.......
ffffffffc0016c00:	66 6f 75 6e 64 20 75 cc 00 6c 01 c0 ff ff ff ff     found u..l......
ffffffffc0016c10:	07 00 00 00 00 00 00 00 74 65 01 c0 ff ff ff ff     ........te......
ffffffffc0016c20:	19 00 00 00 00 00 00 00 75 02 00 00 0d 00 00 00     ........u.......
ffffffffc0016c30:	c0 1c 01 c0 ff ff ff ff 10 00 00 00 00 00 00 00     ................
ffffffffc0016c40:	08 00 00 00 00 00 00 00 a0 2e 01 c0 ff ff ff ff     ................
ffffffffc0016c50:	61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65 64     assertion failed
ffffffffc0016c60:	3a 20 73 65 6c 66 2e 69 73 5f 73 6f 6d 65 28 29     : self.is_some()
ffffffffc0016c70:	55 41 52 54 20 43 4f 4d 31 20 69 6e 69 74 69 61     UART COM1 initia
ffffffffc0016c80:	6c 69 7a 61 74 69 6f 6e 20 66 61 69 6c 65 64 21     lization failed!
ffffffffc0016c90:	61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65 64     assertion failed
ffffffffc0016ca0:	3a 20 69 20 3c 20 61 72 67 73 2e 6c 65 6e 28 29     : i < args.len()
ffffffffc0016cb0:	69 6e 64 65 78 20 6f 75 74 20 6f 66 20 62 6f 75     index out of bou
ffffffffc0016cc0:	6e 64 73 3a 20 74 68 65 20 6c 65 6e 20 69 73 20     nds: the len is 
ffffffffc0016cd0:	61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65 64     assertion failed
ffffffffc0016ce0:	3a 20 73 65 6c 66 2e 69 73 3a 3a 3c 54 3e 28 29     : self.is::<T>()
ffffffffc0016cf0:	6b 65 72 6e 65 6c 2f 73 72 63 2f 6f 75 74 2f 75     kernel/src/out/u
ffffffffc0016d00:	61 72 74 2e 72 73 cc cc f0 6c 01 c0 ff ff ff ff     art.rs...l......
ffffffffc0016d10:	16 00 00 00 00 00 00 00 18 00 00 00 07 00 00 00     ................
ffffffffc0016d20:	f0 6c 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     .l..............
ffffffffc0016d30:	57 01 00 00 0a 00 00 00 cc cc cc cc cc cc cc cc     W...............

ffffffffc0016d40 <str.0>:
ffffffffc0016d40:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0016d50:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....
ffffffffc0016d60:	f0 6c 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     .l..............
ffffffffc0016d70:	64 01 00 00 0e 00 00 00 f0 6c 01 c0 ff ff ff ff     d........l......
ffffffffc0016d80:	16 00 00 00 00 00 00 00 cd 01 00 00 1c 00 00 00     ................
ffffffffc0016d90:	f0 6c 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     .l..............
ffffffffc0016da0:	ce 01 00 00 1c 00 00 00 f0 6c 01 c0 ff ff ff ff     .........l......
ffffffffc0016db0:	16 00 00 00 00 00 00 00 cf 01 00 00 24 00 00 00     ............$...
ffffffffc0016dc0:	f0 6c 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     .l..............
ffffffffc0016dd0:	d0 01 00 00 24 00 00 00 f0 6c 01 c0 ff ff ff ff     ....$....l......
ffffffffc0016de0:	16 00 00 00 00 00 00 00 d1 01 00 00 1c 00 00 00     ................
ffffffffc0016df0:	50 6f 72 74 20 52 2f 57 20 74 65 73 74 20 66 61     Port R/W test fa
ffffffffc0016e00:	69 6c 65 64 21 cc cc cc                             iled!...

ffffffffc0016e08 <anon.78c0aed90dd6374142d6f5f78e831491.2.llvm.6580611916572223585>:
ffffffffc0016e08:	50 20 01 c0 ff ff ff ff 08 00 00 00 00 00 00 00     P ..............
ffffffffc0016e18:	08 00 00 00 00 00 00 00 00 22 01 c0 ff ff ff ff     ........."......
ffffffffc0016e28:	60 20 01 c0 ff ff ff ff a0 21 01 c0 ff ff ff ff     ` .......!......
ffffffffc0016e38:	12 23 01 c0 ff ff ff ff 80 23 01 c0 ff ff ff ff     .#.......#......
ffffffffc0016e48:	94 23 01 c0 ff ff ff ff c4 23 01 c0 ff ff ff ff     .#.......#......

ffffffffc0016e58 <anon.a8b02e17e137e0149db216ad59ceaace.0.llvm.2330526326397655001>:
ffffffffc0016e58:	69 6e 74 65 72 6e 61 6c 20 65 72 72 6f 72 3a 20     internal error: 
ffffffffc0016e68:	65 6e 74 65 72 65 64 20 75 6e 72 65 61 63 68 61     entered unreacha
ffffffffc0016e78:	62 6c 65 20 63 6f 64 65 3a 20 cc cc cc cc cc cc     ble code: ......

ffffffffc0016e88 <anon.a8b02e17e137e0149db216ad59ceaace.1.llvm.2330526326397655001>:
ffffffffc0016e88:	58 6e 01 c0 ff ff ff ff 2a 00 00 00 00 00 00 00     Xn......*.......

ffffffffc0016e98 <anon.a8b02e17e137e0149db216ad59ceaace.2.llvm.2330526326397655001>:
ffffffffc0016e98:	4c 61 7a 79 20 69 6e 73 74 61 6e 63 65 20 68 61     Lazy instance ha
ffffffffc0016ea8:	73 20 70 72 65 76 69 6f 75 73 6c 79 20 62 65 65     s previously bee
ffffffffc0016eb8:	6e 20 70 6f 69 73 6f 6e 65 64                       n poisoned

ffffffffc0016ec2 <anon.a8b02e17e137e0149db216ad59ceaace.3.llvm.2330526326397655001>:
ffffffffc0016ec2:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 63 61 72     /home/sfbea/.car
ffffffffc0016ed2:	67 6f 2f 72 65 67 69 73 74 72 79 2f 73 72 63 2f     go/registry/src/
ffffffffc0016ee2:	67 69 74 68 75 62 2e 63 6f 6d 2d 31 65 63 63 36     github.com-1ecc6
ffffffffc0016ef2:	32 39 39 64 62 39 65 63 38 32 33 2f 73 70 69 6e     299db9ec823/spin
ffffffffc0016f02:	2d 30 2e 39 2e 32 2f 73 72 63 2f 6c 61 7a 79 2e     -0.9.2/src/lazy.
ffffffffc0016f12:	72 73 cc cc cc cc                                   rs....

ffffffffc0016f18 <anon.a8b02e17e137e0149db216ad59ceaace.4.llvm.2330526326397655001>:
ffffffffc0016f18:	c2 6e 01 c0 ff ff ff ff 52 00 00 00 00 00 00 00     .n......R.......
ffffffffc0016f28:	5e 00 00 00 15 00 00 00                             ^.......

ffffffffc0016f30 <anon.a8b02e17e137e0149db216ad59ceaace.5.llvm.2330526326397655001>:
ffffffffc0016f30:	4f 6e 63 65 20 70 72 65 76 69 6f 75 73 6c 79 20     Once previously 
ffffffffc0016f40:	70 6f 69 73 6f 6e 65 64 20 62 79 20 61 20 70 61     poisoned by a pa
ffffffffc0016f50:	6e 69 63 6b 65 64                                   nicked

ffffffffc0016f56 <anon.a8b02e17e137e0149db216ad59ceaace.6.llvm.2330526326397655001>:
ffffffffc0016f56:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 63 61 72     /home/sfbea/.car
ffffffffc0016f66:	67 6f 2f 72 65 67 69 73 74 72 79 2f 73 72 63 2f     go/registry/src/
ffffffffc0016f76:	67 69 74 68 75 62 2e 63 6f 6d 2d 31 65 63 63 36     github.com-1ecc6
ffffffffc0016f86:	32 39 39 64 62 39 65 63 38 32 33 2f 73 70 69 6e     299db9ec823/spin
ffffffffc0016f96:	2d 30 2e 39 2e 32 2f 73 72 63 2f 6f 6e 63 65 2e     -0.9.2/src/once.
ffffffffc0016fa6:	72 73                                               rs

ffffffffc0016fa8 <anon.a8b02e17e137e0149db216ad59ceaace.7.llvm.2330526326397655001>:
ffffffffc0016fa8:	56 6f 01 c0 ff ff ff ff 52 00 00 00 00 00 00 00     Vo......R.......
ffffffffc0016fb8:	28 01 00 00 25 00 00 00                             (...%...

ffffffffc0016fc0 <anon.a8b02e17e137e0149db216ad59ceaace.8.llvm.2330526326397655001>:
ffffffffc0016fc0:	4f 6e 63 65 20 70 61 6e 69 63 6b 65 64 cc cc cc     Once panicked...

ffffffffc0016fd0 <anon.a8b02e17e137e0149db216ad59ceaace.9.llvm.2330526326397655001>:
ffffffffc0016fd0:	56 6f 01 c0 ff ff ff ff 52 00 00 00 00 00 00 00     Vo......R.......
ffffffffc0016fe0:	e5 00 00 00 21 00 00 00                             ....!...

ffffffffc0016fe8 <anon.a8b02e17e137e0149db216ad59ceaace.10.llvm.2330526326397655001>:
ffffffffc0016fe8:	45 6e 63 6f 75 6e 74 65 72 65 64 20 49 4e 43 4f     Encountered INCO
ffffffffc0016ff8:	4d 50 4c 45 54 45 20 77 68 65 6e 20 70 6f 6c 6c     MPLETE when poll
ffffffffc0017008:	69 6e 67 20 4f 6e 63 65                             ing Once

ffffffffc0017010 <anon.a8b02e17e137e0149db216ad59ceaace.11.llvm.2330526326397655001>:
ffffffffc0017010:	e8 6f 01 c0 ff ff ff ff 28 00 00 00 00 00 00 00     .o......(.......

ffffffffc0017020 <anon.a8b02e17e137e0149db216ad59ceaace.12.llvm.2330526326397655001>:
ffffffffc0017020:	56 6f 01 c0 ff ff ff ff 52 00 00 00 00 00 00 00     Vo......R.......
ffffffffc0017030:	ea 00 00 00 19 00 00 00 cc cc cc cc cc cc cc cc     ................

ffffffffc0017040 <str.0>:
ffffffffc0017040:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0017050:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....

ffffffffc0017060 <anon.509ace6d7f668bbf4d9ad634ea25f719.4.llvm.10247169838892840880>:
ffffffffc0017060:	00 24 01 c0 ff ff ff ff 00 00 00 00 00 00 00 00     .$..............
ffffffffc0017070:	01 00 00 00 00 00 00 00 f0 48 01 c0 ff ff ff ff     .........H......
ffffffffc0017080:	0a cc cc cc cc cc cc cc 80 70 01 c0 ff ff ff ff     .........p......
ffffffffc0017090:	01 00 00 00 00 00 00 00                             ........

ffffffffc0017098 <anon.509ace6d7f668bbf4d9ad634ea25f719.11.llvm.10247169838892840880>:
ffffffffc0017098:	6b 65 72 6e 65 6c 2f 73 72 63 2f 6d 65 6d 6d 2f     kernel/src/memm/
ffffffffc00170a8:	6d 6f 64 2e 72 73                                   mod.rs

ffffffffc00170ae <anon.509ace6d7f668bbf4d9ad634ea25f719.12.llvm.10247169838892840880>:
ffffffffc00170ae:	49 6e 73 75 66 66 69 63 69 65 6e 74 20 70 68 79     Insufficient phy
ffffffffc00170be:	73 69 63 61 6c 20 6d 65 6d 6f 72 79 20 65 78 63     sical memory exc
ffffffffc00170ce:	65 70 74 69 6f 6e 21 cc cc cc                       eption!...

ffffffffc00170d8 <anon.509ace6d7f668bbf4d9ad634ea25f719.13.llvm.10247169838892840880>:
ffffffffc00170d8:	98 70 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     .p..............
ffffffffc00170e8:	a8 01 00 00 0e 00 00 00 61 73 73 65 72 74 69 6f     ........assertio
ffffffffc00170f8:	6e 20 66 61 69 6c 65 64 3a 20 73 69 7a 65 20 21     n failed: size !
ffffffffc0017108:	3d 20 30 cc cc cc cc cc 98 70 01 c0 ff ff ff ff     = 0......p......
ffffffffc0017118:	16 00 00 00 00 00 00 00 b4 01 00 00 09 00 00 00     ................
ffffffffc0017128:	98 70 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     .p..............
ffffffffc0017138:	b7 01 00 00 26 00 00 00 70 72 65 20 6d 61 70 20     ....&...pre map 
ffffffffc0017148:	6f 66 66 73 65 74 cc cc 40 71 01 c0 ff ff ff ff     offset..@q......
ffffffffc0017158:	0e 00 00 00 00 00 00 00 70 6f 73 74 20 6d 61 70     ........post map
ffffffffc0017168:	20 6f 66 66 73 65 74 cc 60 71 01 c0 ff ff ff ff      offset.`q......
ffffffffc0017178:	0f 00 00 00 00 00 00 00                             ........

ffffffffc0017180 <str.0>:
ffffffffc0017180:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0017190:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....
ffffffffc00171a0:	2f 6d 6e 74 2f 64 2f 73 72 63 2f 72 75 73 74 2f     /mnt/d/src/rust/
ffffffffc00171b0:	74 61 75 6f 73 2f 61 6d 64 36 34 2f 73 72 63 2f     tauos/amd64/src/
ffffffffc00171c0:	70 61 67 69 6e 67 2e 72 73 61 64 64 72 20 69 73     paging.rsaddr is
ffffffffc00171d0:	20 6e 6f 74 20 70 61 67 65 2d 61 6c 69 67 6e 65      not page-aligne
ffffffffc00171e0:	64 20 6f 72 20 69 73 20 74 6f 6f 20 6c 61 72 67     d or is too larg
ffffffffc00171f0:	65 20 66 6f 72 20 41 4d 44 36 34 20 61 72 63 68     e for AMD64 arch
ffffffffc0017200:	69 74 65 63 74 75 72 65 c9 71 01 c0 ff ff ff ff     itecture.q......
ffffffffc0017210:	3f 00 00 00 00 00 00 00 a0 71 01 c0 ff ff ff ff     ?........q......
ffffffffc0017220:	29 00 00 00 00 00 00 00 86 00 00 00 09 00 00 00     )...............
ffffffffc0017230:	6b 65 72 6e 65 6c 2f 73 72 63 2f 6d 65 6d 6d 2f     kernel/src/memm/
ffffffffc0017240:	6d 6f 64 2e 72 73 cc cc 30 72 01 c0 ff ff ff ff     mod.rs..0r......
ffffffffc0017250:	16 00 00 00 00 00 00 00 78 00 00 00 2a 00 00 00     ........x...*...

ffffffffc0017260 <str.3>:
ffffffffc0017260:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc0017270:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0017280:	77 cc cc cc cc cc cc cc 30 72 01 c0 ff ff ff ff     w.......0r......
ffffffffc0017290:	16 00 00 00 00 00 00 00 79 00 00 00 19 00 00 00     ........y.......
ffffffffc00172a0:	30 72 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     0r..............
ffffffffc00172b0:	90 00 00 00 11 00 00 00                             ........

ffffffffc00172b8 <anon.0758f805cb4ca8c48a60392ffe5bdf67.0.llvm.13672949638510867836>:
ffffffffc00172b8:	c0 2d 01 c0 ff ff ff ff 08 00 00 00 00 00 00 00     .-..............
ffffffffc00172c8:	08 00 00 00 00 00 00 00 40 2e 01 c0 ff ff ff ff     ........@.......
ffffffffc00172d8:	61 6d 64 36 34 2f 73 72 63 2f 70 61 67 69 6e 67     amd64/src/paging
ffffffffc00172e8:	2e 72 73 cc cc cc cc cc d8 72 01 c0 ff ff ff ff     .rs......r......
ffffffffc00172f8:	13 00 00 00 00 00 00 00 26 01 00 00 0d 00 00 00     ........&.......
ffffffffc0017308:	cc cc cc cc cc cc cc cc                             ........

ffffffffc0017310 <str.1>:
ffffffffc0017310:	61 74 74 65 6d 70 74 20 74 6f 20 6d 75 6c 74 69     attempt to multi
ffffffffc0017320:	70 6c 79 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     ply with overflo
ffffffffc0017330:	77 cc cc cc cc cc cc cc d8 72 01 c0 ff ff ff ff     w........r......
ffffffffc0017340:	13 00 00 00 00 00 00 00 26 01 00 00 05 00 00 00     ........&.......

ffffffffc0017350 <str.2>:
ffffffffc0017350:	61 74 74 65 6d 70 74 20 74 6f 20 73 68 69 66 74     attempt to shift
ffffffffc0017360:	20 6c 65 66 74 20 77 69 74 68 20 6f 76 65 72 66      left with overf
ffffffffc0017370:	6c 6f 77 2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e     low/home/sfbea/.
ffffffffc0017380:	72 75 73 74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e     rustup/toolchain
ffffffffc0017390:	73 2f 6e 69 67 68 74 6c 79 2d 78 38 36 5f 36 34     s/nightly-x86_64
ffffffffc00173a0:	2d 75 6e 6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67     -unknown-linux-g
ffffffffc00173b0:	6e 75 2f 6c 69 62 2f 72 75 73 74 6c 69 62 2f 73     nu/lib/rustlib/s
ffffffffc00173c0:	72 63 2f 72 75 73 74 2f 6c 69 62 72 61 72 79 2f     rc/rust/library/
ffffffffc00173d0:	63 6f 72 65 2f 73 72 63 2f 66 6d 74 2f 6e 75 6d     core/src/fmt/num
ffffffffc00173e0:	2e 72 73 cc cc cc cc cc 73 73 01 c0 ff ff ff ff     .rs.....ss......
ffffffffc00173f0:	70 00 00 00 00 00 00 00 65 00 00 00 14 00 00 00     p.......e.......
ffffffffc0017400:	30 78                                               0x

ffffffffc0017402 <anon.1a2e34b194c5f77c701ef57b3b7b79fa.6.llvm.17464636063181802738>:
ffffffffc0017402:	30 30 30 31 30 32 30 33 30 34 30 35 30 36 30 37     0001020304050607
ffffffffc0017412:	30 38 30 39 31 30 31 31 31 32 31 33 31 34 31 35     0809101112131415
ffffffffc0017422:	31 36 31 37 31 38 31 39 32 30 32 31 32 32 32 33     1617181920212223
ffffffffc0017432:	32 34 32 35 32 36 32 37 32 38 32 39 33 30 33 31     2425262728293031
ffffffffc0017442:	33 32 33 33 33 34 33 35 33 36 33 37 33 38 33 39     3233343536373839
ffffffffc0017452:	34 30 34 31 34 32 34 33 34 34 34 35 34 36 34 37     4041424344454647
ffffffffc0017462:	34 38 34 39 35 30 35 31 35 32 35 33 35 34 35 35     4849505152535455
ffffffffc0017472:	35 36 35 37 35 38 35 39 36 30 36 31 36 32 36 33     5657585960616263
ffffffffc0017482:	36 34 36 35 36 36 36 37 36 38 36 39 37 30 37 31     6465666768697071
ffffffffc0017492:	37 32 37 33 37 34 37 35 37 36 37 37 37 38 37 39     7273747576777879
ffffffffc00174a2:	38 30 38 31 38 32 38 33 38 34 38 35 38 36 38 37     8081828384858687
ffffffffc00174b2:	38 38 38 39 39 30 39 31 39 32 39 33 39 34 39 35     8889909192939495
ffffffffc00174c2:	39 36 39 37 39 38 39 39 cc cc cc cc cc cc 7c 3d     96979899......|=
ffffffffc00174d2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc00174e2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc00174f2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017502:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017512:	01 c0 ff ff ff ff e1 3d 01 c0 ff ff ff ff f0 3d     .......=.......=
ffffffffc0017522:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017532:	01 c0 ff ff ff ff ff 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017542:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017552:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017562:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017572:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017582:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc0017592:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc00175a2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc00175b2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc00175c2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff a3 3d     .......=.......=
ffffffffc00175d2:	01 c0 ff ff ff ff a3 3d 01 c0 ff ff ff ff d5 3d     .......=.......=
ffffffffc00175e2:	01 c0 ff ff ff ff 71 3f 01 c0 ff ff ff ff 40 3f     ......q?......@?
ffffffffc00175f2:	01 c0 ff ff ff ff 50 3f 01 c0 ff ff ff ff a0 3e     ......P?.......>
ffffffffc0017602:	01 c0 ff ff ff ff 71 3f 01 c0 ff ff ff ff 50 3f     ......q?......P?
ffffffffc0017612:	01 c0 ff ff ff ff b6 3e 01 c0 ff ff ff ff 10 3f     .......>.......?
ffffffffc0017622:	01 c0 ff ff ff ff 30 3f 01 c0 ff ff ff ff 20 3f     ......0?...... ?
ffffffffc0017632:	01 c0 ff ff ff ff 68 42 01 c0 ff ff ff ff a3 41     ......hB.......A
ffffffffc0017642:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017652:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017662:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017672:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff 5e 41     .......A......^A
ffffffffc0017682:	01 c0 ff ff ff ff de 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017692:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff fe 41     .......A.......A
ffffffffc00176a2:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc00176b2:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc00176c2:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc00176d2:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc00176e2:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc00176f2:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017702:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017712:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017722:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017732:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017742:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017752:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff a3 41     .......A.......A
ffffffffc0017762:	01 c0 ff ff ff ff a3 41 01 c0 ff ff ff ff 1e 42     .......A.......B
ffffffffc0017772:	01 c0 ff ff ff ff 2f 43 01 c0 ff ff ff ff a1 42     ....../C.......B
ffffffffc0017782:	01 c0 ff ff ff ff 80 42 01 c0 ff ff ff ff a8 42     .......B.......B
ffffffffc0017792:	01 c0 ff ff ff ff 2f 43 01 c0 ff ff ff ff 80 42     ....../C.......B
ffffffffc00177a2:	01 c0 ff ff ff ff be 42 01 c0 ff ff ff ff 0b 43     .......B.......C
ffffffffc00177b2:	01 c0 ff ff ff ff 17 43 01 c0 ff ff ff ff 23 43     .......C......#C
ffffffffc00177c2:	01 c0 ff ff ff ff 2f 68 6f 6d 65 2f 73 66 62 65     ....../home/sfbe
ffffffffc00177d2:	61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c 63 68     a/.rustup/toolch
ffffffffc00177e2:	61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78 38 36     ains/nightly-x86
ffffffffc00177f2:	5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69 6e 75     _64-unknown-linu
ffffffffc0017802:	78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74 6c 69     x-gnu/lib/rustli
ffffffffc0017812:	62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62 72 61     b/src/rust/libra
ffffffffc0017822:	72 79 2f 63 6f 72 65 2f 73 72 63 2f 63 68 61 72     ry/core/src/char
ffffffffc0017832:	2f 63 6f 6e 76 65 72 74 2e 72 73 cc cc cc c8 77     /convert.rs....w
ffffffffc0017842:	01 c0 ff ff ff ff 75 00 00 00 00 00 00 00 1a 00     ......u.........
ffffffffc0017852:	00 00 33 00 00 00 cc cc cc cc cc cc cc cc           ..3...........

ffffffffc0017860 <str.0>:
ffffffffc0017860:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc0017870:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0017880:	77 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc     w...............

ffffffffc0017890 <str.1.llvm.175273845903478457>:
ffffffffc0017890:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc00178a0:	69 74 68 20 6f 76 65 72 66 6c 6f 77 63 61 6c 6c     ith overflowcall
ffffffffc00178b0:	65 64 20 60 4f 70 74 69 6f 6e 3a 3a 75 6e 77 72     ed `Option::unwr
ffffffffc00178c0:	61 70 28 29 60 20 6f 6e 20 61 20 60 4e 6f 6e 65     ap()` on a `None
ffffffffc00178d0:	60 20 76 61 6c 75 65                                ` value

ffffffffc00178d7 <anon.a8d1cc60c79a1cdcb75007a2c9845a77.9.llvm.175273845903478457>:
ffffffffc00178d7:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc00178e7:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc00178f7:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0017907:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0017917:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0017927:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0017937:	65 2f 73 72 63 2f 66 6d 74 2f 6d 6f 64 2e 72 73     e/src/fmt/mod.rs
ffffffffc0017947:	61 73 73 65 72 74 69 6f 6e 20 66 61 69 6c 65 64     assertion failed
ffffffffc0017957:	3a 20 61 72 67 2e 70 6f 73 69 74 69 6f 6e 20 3c     : arg.position <
ffffffffc0017967:	20 61 72 67 73 2e 6c 65 6e 28 29 cc cc cc cc cc      args.len().....
ffffffffc0017977:	cc d7 78 01 c0 ff ff ff ff 70 00 00 00 00 00 00     ..x......p......
ffffffffc0017987:	00 d6 04 00 00 05 00 00 00 d7 78 01 c0 ff ff ff     ..........x.....
ffffffffc0017997:	ff 70 00 00 00 00 00 00 00 e4 04 00 00 0d 00 00     .p..............
ffffffffc00179a7:	00 d7 78 01 c0 ff ff ff ff 70 00 00 00 00 00 00     ..x......p......
ffffffffc00179b7:	00 4a 05 00 00 0d 00 00 00 d7 78 01 c0 ff ff ff     .J........x.....
ffffffffc00179c7:	ff 70 00 00 00 00 00 00 00 4d 05 00 00 0d 00 00     .p.......M......
ffffffffc00179d7:	00 d7 78 01 c0 ff ff ff ff 70 00 00 00 00 00 00     ..x......p......
ffffffffc00179e7:	00 51 05 00 00 0d 00 00 00 d7 78 01 c0 ff ff ff     .Q........x.....
ffffffffc00179f7:	ff 70 00 00 00 00 00 00 00 74 05 00 00 31 00 00     .p.......t...1..
ffffffffc0017a07:	00 d7 78 01 c0 ff ff ff ff 70 00 00 00 00 00 00     ..x......p......
ffffffffc0017a17:	00 7d 05 00 00 31 00 00 00                          .}...1...

ffffffffc0017a20 <anon.a8d1cc60c79a1cdcb75007a2c9845a77.22.llvm.175273845903478457>:
ffffffffc0017a20:	d7 78 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     .x......p.......
ffffffffc0017a30:	e1 05 00 00 38 00 00 00 d7 78 01 c0 ff ff ff ff     ....8....x......
ffffffffc0017a40:	70 00 00 00 00 00 00 00 8c 08 00 00 1e 00 00 00     p...............
ffffffffc0017a50:	d7 78 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     .x......p.......
ffffffffc0017a60:	90 08 00 00 18 00 00 00 d7 78 01 c0 ff ff ff ff     .........x......
ffffffffc0017a70:	70 00 00 00 00 00 00 00 93 08 00 00 16 00 00 00     p...............
ffffffffc0017a80:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0017a90:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0017aa0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0017ab0:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0017ac0:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0017ad0:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0017ae0:	65 2f 73 72 63 2f 73 74 72 2f 69 74 65 72 2e 72     e/src/str/iter.r
ffffffffc0017af0:	73 cc cc cc cc cc cc cc 80 7a 01 c0 ff ff ff ff     s........z......
ffffffffc0017b00:	71 00 00 00 00 00 00 00 91 00 00 00 26 00 00 00     q...........&...
ffffffffc0017b10:	80 7a 01 c0 ff ff ff ff 71 00 00 00 00 00 00 00     .z......q.......
ffffffffc0017b20:	91 00 00 00 11 00 00 00 2f 68 6f 6d 65 2f 73 66     ......../home/sf
ffffffffc0017b30:	62 65 61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c     bea/.rustup/tool
ffffffffc0017b40:	63 68 61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78     chains/nightly-x
ffffffffc0017b50:	38 36 5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69     86_64-unknown-li
ffffffffc0017b60:	6e 75 78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74     nux-gnu/lib/rust
ffffffffc0017b70:	6c 69 62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62     lib/src/rust/lib
ffffffffc0017b80:	72 61 72 79 2f 63 6f 72 65 2f 73 72 63 2f 73 74     rary/core/src/st
ffffffffc0017b90:	72 2f 74 72 61 69 74 73 2e 72 73 cc cc cc cc cc     r/traits.rs.....
ffffffffc0017ba0:	28 7b 01 c0 ff ff ff ff 73 00 00 00 00 00 00 00     ({......s.......
ffffffffc0017bb0:	ca 00 00 00 13 00 00 00 28 7b 01 c0 ff ff ff ff     ........({......
ffffffffc0017bc0:	73 00 00 00 00 00 00 00 62 01 00 00 13 00 00 00     s.......b.......
ffffffffc0017bd0:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0017be0:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0017bf0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0017c00:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0017c10:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0017c20:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0017c30:	65 2f 73 72 63 2f 73 74 72 2f 76 61 6c 69 64 61     e/src/str/valida
ffffffffc0017c40:	74 69 6f 6e 73 2e 72 73 d0 7b 01 c0 ff ff ff ff     tions.rs.{......
ffffffffc0017c50:	78 00 00 00 00 00 00 00 31 00 00 00 24 00 00 00     x.......1...$...
ffffffffc0017c60:	d0 7b 01 c0 ff ff ff ff 78 00 00 00 00 00 00 00     .{......x.......
ffffffffc0017c70:	38 00 00 00 28 00 00 00 d0 7b 01 c0 ff ff ff ff     8...(....{......
ffffffffc0017c80:	78 00 00 00 00 00 00 00 40 00 00 00 2c 00 00 00     x.......@...,...

ffffffffc0017c90 <str.1.llvm.9191353963870608334>:
ffffffffc0017c90:	61 74 74 65 6d 70 74 20 74 6f 20 6d 75 6c 74 69     attempt to multi
ffffffffc0017ca0:	70 6c 79 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     ply with overflo
ffffffffc0017cb0:	77 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc     w...............

ffffffffc0017cc0 <str.2.llvm.9191353963870608334>:
ffffffffc0017cc0:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0017cd0:	69 74 68 20 6f 76 65 72 66 6c 6f 77                 ith overflow

ffffffffc0017cdc <anon.0bd8a6bed4d097dd68ccb46be13cad87.35.llvm.9191353963870608334>:
ffffffffc0017cdc:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0017cec:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0017cfc:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0017d0c:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0017d1c:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0017d2c:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0017d3c:	65 2f 73 72 63 2f 63 68 61 72 2f 6d 6f 64 2e 72     e/src/char/mod.r
ffffffffc0017d4c:	73 cc cc cc                                         s...

ffffffffc0017d50 <anon.0bd8a6bed4d097dd68ccb46be13cad87.36.llvm.9191353963870608334>:
ffffffffc0017d50:	dc 7c 01 c0 ff ff ff ff 71 00 00 00 00 00 00 00     .|......q.......
ffffffffc0017d60:	bc 00 00 00 35 00 00 00                             ....5...

ffffffffc0017d68 <anon.0bd8a6bed4d097dd68ccb46be13cad87.37.llvm.9191353963870608334>:
ffffffffc0017d68:	dc 7c 01 c0 ff ff ff ff 71 00 00 00 00 00 00 00     .|......q.......
ffffffffc0017d78:	bc 00 00 00 21 00 00 00                             ....!...

ffffffffc0017d80 <str.4.llvm.9191353963870608334>:
ffffffffc0017d80:	61 74 74 65 6d 70 74 20 74 6f 20 73 68 69 66 74     attempt to shift
ffffffffc0017d90:	20 72 69 67 68 74 20 77 69 74 68 20 6f 76 65 72      right with over
ffffffffc0017da0:	66 6c 6f 77                                         flow

ffffffffc0017da4 <anon.0bd8a6bed4d097dd68ccb46be13cad87.98.llvm.9191353963870608334>:
ffffffffc0017da4:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0017db4:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0017dc4:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0017dd4:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0017de4:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0017df4:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0017e04:	65 2f 73 72 63 2f 69 74 65 72 2f 74 72 61 69 74     e/src/iter/trait
ffffffffc0017e14:	73 2f 61 63 63 75 6d 2e 72 73 cc cc                 s/accum.rs..

ffffffffc0017e20 <anon.0bd8a6bed4d097dd68ccb46be13cad87.99.llvm.9191353963870608334>:
ffffffffc0017e20:	a4 7d 01 c0 ff ff ff ff 7a 00 00 00 00 00 00 00     .}......z.......
ffffffffc0017e30:	8d 00 00 00 01 00 00 00 20 46 01 c0 ff ff ff ff     ........ F......
	...
ffffffffc0017e48:	01 00 00 00 00 00 00 00 10 49 01 c0 ff ff ff ff     .........I......
ffffffffc0017e58:	20 62 75 74 20 74 68 65 20 69 6e 64 65 78 20 69      but the index i
ffffffffc0017e68:	73 20 cc cc cc cc cc cc b0 6c 01 c0 ff ff ff ff     s .......l......
ffffffffc0017e78:	20 00 00 00 00 00 00 00 58 7e 01 c0 ff ff ff ff      .......X~......
ffffffffc0017e88:	12 00 00 00 00 00 00 00 6d 61 74 63 68 65 73 21     ........matches!
ffffffffc0017e98:	3d 3d 3d 61 73 73 65 72 74 69 6f 6e 20 66 61 69     ===assertion fai
ffffffffc0017ea8:	6c 65 64 3a 20 60 28 6c 65 66 74 20 20 72 69 67     led: `(left  rig
ffffffffc0017eb8:	68 74 29 60 0a 20 20 6c 65 66 74 3a 20 60 60 2c     ht)`.  left: ``,
ffffffffc0017ec8:	0a 20 72 69 67 68 74 3a 20 60 60 3a 20 cc cc cc     . right: ``: ...
ffffffffc0017ed8:	9b 7e 01 c0 ff ff ff ff 19 00 00 00 00 00 00 00     .~..............
ffffffffc0017ee8:	b4 7e 01 c0 ff ff ff ff 12 00 00 00 00 00 00 00     .~..............
ffffffffc0017ef8:	c6 7e 01 c0 ff ff ff ff 0c 00 00 00 00 00 00 00     .~..............
ffffffffc0017f08:	d2 7e 01 c0 ff ff ff ff 03 00 00 00 00 00 00 00     .~..............
ffffffffc0017f18:	60 cc cc cc cc cc cc cc 9b 7e 01 c0 ff ff ff ff     `........~......
ffffffffc0017f28:	19 00 00 00 00 00 00 00 b4 7e 01 c0 ff ff ff ff     .........~......
ffffffffc0017f38:	12 00 00 00 00 00 00 00 c6 7e 01 c0 ff ff ff ff     .........~......
ffffffffc0017f48:	0c 00 00 00 00 00 00 00 18 7f 01 c0 ff ff ff ff     ................
ffffffffc0017f58:	01 00 00 00 00 00 00 00 41 6c 6c 6f 63 45 72 72     ........AllocErr
ffffffffc0017f68:	6f 72 cc cc cc cc cc cc                             or......

ffffffffc0017f70 <anon.66e0b9fa34880cc4e688a55755bc4078.28.llvm.10189563460319923796>:
ffffffffc0017f70:	3a cc cc cc cc cc cc cc                             :.......

ffffffffc0017f78 <anon.66e0b9fa34880cc4e688a55755bc4078.29.llvm.10189563460319923796>:
ffffffffc0017f78:	70 7f 01 c0 ff ff ff ff 00 00 00 00 00 00 00 00     p...............
ffffffffc0017f88:	70 7f 01 c0 ff ff ff ff 01 00 00 00 00 00 00 00     p...............
ffffffffc0017f98:	70 7f 01 c0 ff ff ff ff 01 00 00 00 00 00 00 00     p...............
ffffffffc0017fa8:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0017fb8:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0017fc8:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0017fd8:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0017fe8:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0017ff8:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0018008:	65 2f 73 72 63 2f 61 6e 79 2e 72 73 cc cc cc cc     e/src/any.rs....
ffffffffc0018018:	a8 7f 01 c0 ff ff ff ff 6c 00 00 00 00 00 00 00     ........l.......
ffffffffc0018028:	21 01 00 00 09 00 00 00 70 61 6e 69 63 6b 65 64     !.......panicked
ffffffffc0018038:	20 61 74 20 27 27 2c 20 3c 80 01 c0 ff ff ff ff      at '', <.......
ffffffffc0018048:	01 00 00 00 00 00 00 00 3d 80 01 c0 ff ff ff ff     ........=.......
ffffffffc0018058:	03 00 00 00 00 00 00 00                             ........

ffffffffc0018060 <str.0.llvm.11298971602363508172>:
ffffffffc0018060:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0018070:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....

ffffffffc0018080 <str.4.llvm.11298971602363508172>:
ffffffffc0018080:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc0018090:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc00180a0:	77 2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75     w/home/sfbea/.ru
ffffffffc00180b0:	73 74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f     stup/toolchains/
ffffffffc00180c0:	6e 69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75     nightly-x86_64-u
ffffffffc00180d0:	6e 6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75     nknown-linux-gnu
ffffffffc00180e0:	2f 6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63     /lib/rustlib/src
ffffffffc00180f0:	2f 72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f     /rust/library/co
ffffffffc0018100:	72 65 2f 73 72 63 2f 73 6c 69 63 65 2f 69 6e 64     re/src/slice/ind
ffffffffc0018110:	65 78 2e 72 73 cc cc cc a1 80 01 c0 ff ff ff ff     ex.rs...........
ffffffffc0018120:	74 00 00 00 00 00 00 00 1e 01 00 00 47 00 00 00     t...........G...
ffffffffc0018130:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0018140:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0018150:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0018160:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0018170:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0018180:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0018190:	65 2f 73 72 63 2f 73 6c 69 63 65 2f 6d 6f 64 2e     e/src/slice/mod.
ffffffffc00181a0:	72 73 cc cc cc cc cc cc 30 81 01 c0 ff ff ff ff     rs......0.......
ffffffffc00181b0:	72 00 00 00 00 00 00 00 89 0d 00 00 36 00 00 00     r...........6...
ffffffffc00181c0:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc00181d0:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc00181e0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc00181f0:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0018200:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0018210:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0018220:	65 2f 73 72 63 2f 73 74 72 2f 63 6f 75 6e 74 2e     e/src/str/count.
ffffffffc0018230:	72 73 cc cc cc cc cc cc c0 81 01 c0 ff ff ff ff     rs..............
ffffffffc0018240:	72 00 00 00 00 00 00 00 47 00 00 00 15 00 00 00     r.......G.......
ffffffffc0018250:	c0 81 01 c0 ff ff ff ff 72 00 00 00 00 00 00 00     ........r.......
ffffffffc0018260:	54 00 00 00 11 00 00 00 c0 81 01 c0 ff ff ff ff     T...............
ffffffffc0018270:	72 00 00 00 00 00 00 00 5a 00 00 00 09 00 00 00     r.......Z.......
ffffffffc0018280:	c0 81 01 c0 ff ff ff ff 72 00 00 00 00 00 00 00     ........r.......
ffffffffc0018290:	64 00 00 00 11 00 00 00 c0 81 01 c0 ff ff ff ff     d...............
ffffffffc00182a0:	72 00 00 00 00 00 00 00 66 00 00 00 0d 00 00 00     r.......f.......
ffffffffc00182b0:	3a 20 cc cc cc cc cc cc b0 82 01 c0 ff ff ff ff     : ..............
	...
ffffffffc00182c8:	b0 82 01 c0 ff ff ff ff 02 00 00 00 00 00 00 00     ................
ffffffffc00182d8:	cc cc cc cc cc cc cc cc                             ........

ffffffffc00182e0 <str.0.llvm.14834836203371451150>:
ffffffffc00182e0:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc00182f0:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0018300:	77 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc     w...............

ffffffffc0018310 <str.2>:
ffffffffc0018310:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0018320:	69 74 68 20 6f 76 65 72 66 6c 6f 77 63 61 6c 6c     ith overflowcall
ffffffffc0018330:	65 64 20 60 4f 70 74 69 6f 6e 3a 3a 75 6e 77 72     ed `Option::unwr
ffffffffc0018340:	61 70 28 29 60 20 6f 6e 20 61 20 60 4e 6f 6e 65     ap()` on a `None
ffffffffc0018350:	60 20 76 61 6c 75 65 2f 68 6f 6d 65 2f 73 66 62     ` value/home/sfb
ffffffffc0018360:	65 61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c 63     ea/.rustup/toolc
ffffffffc0018370:	68 61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78 38     hains/nightly-x8
ffffffffc0018380:	36 5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69 6e     6_64-unknown-lin
ffffffffc0018390:	75 78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74 6c     ux-gnu/lib/rustl
ffffffffc00183a0:	69 62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62 72     ib/src/rust/libr
ffffffffc00183b0:	61 72 79 2f 63 6f 72 65 2f 73 72 63 2f 75 6e 69     ary/core/src/uni
ffffffffc00183c0:	63 6f 64 65 2f 70 72 69 6e 74 61 62 6c 65 2e 72     code/printable.r
ffffffffc00183d0:	73 cc cc cc cc cc cc cc 57 83 01 c0 ff ff ff ff     s.......W.......
ffffffffc00183e0:	7a 00 00 00 00 00 00 00 08 00 00 00 18 00 00 00     z...............
ffffffffc00183f0:	57 83 01 c0 ff ff ff ff 7a 00 00 00 00 00 00 00     W.......z.......
ffffffffc0018400:	0a 00 00 00 1c 00 00 00 57 83 01 c0 ff ff ff ff     ........W.......
ffffffffc0018410:	7a 00 00 00 00 00 00 00 1a 00 00 00 36 00 00 00     z...........6...
ffffffffc0018420:	57 83 01 c0 ff ff ff ff 7a 00 00 00 00 00 00 00     W.......z.......
ffffffffc0018430:	1e 00 00 00 09 00 00 00                             ........

ffffffffc0018438 <anon.4a821f7c0280114971449ed0cf6e5daa.23.llvm.14834836203371451150>:
ffffffffc0018438:	00 01 03 05 05 06 06 02 07 06 08 07 09 11 0a 1c     ................
ffffffffc0018448:	0b 19 0c 1a 0d 10 0e 0d 0f 04 10 03 12 12 13 09     ................
ffffffffc0018458:	16 01 17 04 18 01 19 03 1a 07 1b 01 1c 02 1f 16     ................
ffffffffc0018468:	20 03 2b 03 2d 0b 2e 01 30 03 31 02 32 01 a7 02      .+.-...0.1.2...
ffffffffc0018478:	a9 02 aa 04 ab 08 fa 02 fb 05 fd 02 fe 03 ff 09     ................

ffffffffc0018488 <anon.4a821f7c0280114971449ed0cf6e5daa.24.llvm.14834836203371451150>:
ffffffffc0018488:	ad 78 79 8b 8d a2 30 57 58 8b 8c 90 1c dd 0e 0f     .xy...0WX.......
ffffffffc0018498:	4b 4c fb fc 2e 2f 3f 5c 5d 5f e2 84 8d 8e 91 92     KL.../?\]_......
ffffffffc00184a8:	a9 b1 ba bb c5 c6 c9 ca de e4 e5 ff 00 04 11 12     ................
ffffffffc00184b8:	29 31 34 37 3a 3b 3d 49 4a 5d 84 8e 92 a9 b1 b4     )147:;=IJ]......
ffffffffc00184c8:	ba bb c6 ca ce cf e4 e5 00 04 0d 0e 11 12 29 31     ..............)1
ffffffffc00184d8:	34 3a 3b 45 46 49 4a 5e 64 65 84 91 9b 9d c9 ce     4:;EFIJ^de......
ffffffffc00184e8:	cf 0d 11 29 3a 3b 45 49 57 5b 5c 5e 5f 64 65 8d     ...):;EIW[\^_de.
ffffffffc00184f8:	91 a9 b4 ba bb c5 c9 df e4 e5 f0 0d 11 45 49 64     .............EId
ffffffffc0018508:	65 80 84 b2 bc be bf d5 d7 f0 f1 83 85 8b a4 a6     e...............
ffffffffc0018518:	be bf c5 c7 ce cf da db 48 98 bd cd c6 ce cf 49     ........H......I
ffffffffc0018528:	4e 4f 57 59 5e 5f 89 8e 8f b1 b6 b7 bf c1 c6 c7     NOWY^_..........
ffffffffc0018538:	d7 11 16 17 5b 5c f6 f7 fe ff 80 6d 71 de df 0e     ....[\.....mq...
ffffffffc0018548:	1f 6e 6f 1c 1d 5f 7d 7e ae af 7f bb bc 16 17 1e     .no.._}~........
ffffffffc0018558:	1f 46 47 4e 4f 58 5a 5c 5e 7e 7f b5 c5 d4 d5 dc     .FGNOXZ\^~......
ffffffffc0018568:	f0 f1 f5 72 73 8f 74 75 96 26 2e 2f a7 af b7 bf     ...rs.tu.&./....
ffffffffc0018578:	c7 cf d7 df 9a 40 97 98 30 8f 1f d2 d4 ce ff 4e     .....@..0......N
ffffffffc0018588:	4f 5a 5b 07 08 0f 10 27 2f ee ef 6e 6f 37 3d 3f     OZ[....'/..no7=?
ffffffffc0018598:	42 45 90 91 53 67 75 c8 c9 d0 d1 d8 d9 e7 fe ff     BE..Sgu.........

ffffffffc00185a8 <anon.4a821f7c0280114971449ed0cf6e5daa.25.llvm.14834836203371451150>:
ffffffffc00185a8:	00 20 5f 22 82 df 04 82 44 08 1b 04 06 11 81 ac     . _"....D.......
ffffffffc00185b8:	0e 80 ab 05 1f 09 81 1b 03 19 08 01 04 2f 04 34     ............./.4
ffffffffc00185c8:	04 07 03 01 07 06 07 11 0a 50 0f 12 07 55 07 03     .........P...U..
ffffffffc00185d8:	04 1c 0a 09 03 08 03 07 03 02 03 03 03 0c 04 05     ................
ffffffffc00185e8:	03 0b 06 01 0e 15 05 4e 07 1b 07 57 07 02 06 16     .......N...W....
ffffffffc00185f8:	0d 50 04 43 03 2d 03 01 04 11 06 0f 0c 3a 04 1d     .P.C.-.......:..
ffffffffc0018608:	25 5f 20 6d 04 6a 25 80 c8 05 82 b0 03 1a 06 82     %_ m.j%.........
ffffffffc0018618:	fd 03 59 07 16 09 18 09 14 0c 14 0c 6a 06 0a 06     ..Y.........j...
ffffffffc0018628:	1a 06 59 07 2b 05 46 0a 2c 04 0c 04 01 03 31 0b     ..Y.+.F.,.....1.
ffffffffc0018638:	2c 04 1a 06 0b 03 80 ac 06 0a 06 2f 31 4d 03 80     ,........../1M..
ffffffffc0018648:	a4 08 3c 03 0f 03 3c 07 38 08 2b 05 82 ff 11 18     ..<...<.8.+.....
ffffffffc0018658:	08 2f 11 2d 03 21 0f 21 0f 80 8c 04 82 97 19 0b     ./.-.!.!........
ffffffffc0018668:	15 88 94 05 2f 05 3b 07 02 0e 18 09 80 be 22 74     ..../.;......."t
ffffffffc0018678:	0c 80 d6 1a 0c 05 80 ff 05 80 df 0c f2 9d 03 37     ...............7
ffffffffc0018688:	09 81 5c 14 80 b8 08 80 cb 05 0a 18 3b 03 0a 06     ..\.........;...
ffffffffc0018698:	38 08 46 08 0c 06 74 0b 1e 03 5a 04 59 09 80 83     8.F...t...Z.Y...
ffffffffc00186a8:	18 1c 0a 16 09 4c 04 80 8a 06 ab a4 0c 17 04 31     .....L.........1
ffffffffc00186b8:	a1 04 81 da 26 07 0c 05 05 80 a6 10 81 f5 07 01     ....&...........
ffffffffc00186c8:	20 2a 06 4c 04 80 8d 04 80 be 03 1b 03 0f 0d         *.L...........

ffffffffc00186d7 <anon.4a821f7c0280114971449ed0cf6e5daa.26.llvm.14834836203371451150>:
ffffffffc00186d7:	00 06 01 01 03 01 04 02 05 07 07 02 08 08 09 02     ................
ffffffffc00186e7:	0a 05 0b 02 0e 04 10 01 11 02 12 05 13 11 14 01     ................
ffffffffc00186f7:	15 02 17 02 19 0d 1c 05 1d 08 24 01 6a 04 6b 02     ..........$.j.k.
ffffffffc0018707:	af 03 bc 02 cf 02 d1 02 d4 0c d5 09 d6 02 d7 02     ................
ffffffffc0018717:	da 01 e0 05 e1 02 e7 04 e8 02 ee 20 f0 04 f8 02     ........... ....
ffffffffc0018727:	fa 02 fb 01                                         ....

ffffffffc001872b <anon.4a821f7c0280114971449ed0cf6e5daa.27.llvm.14834836203371451150>:
ffffffffc001872b:	0c 27 3b 3e 4e 4f 8f 9e 9e 9f 7b 8b 93 96 a2 b2     .';>NO....{.....
ffffffffc001873b:	ba 86 b1 06 07 09 36 3d 3e 56 f3 d0 d1 04 14 18     ......6=>V......
ffffffffc001874b:	36 37 56 57 7f aa ae af bd 35 e0 12 87 89 8e 9e     67VW.....5......
ffffffffc001875b:	04 0d 0e 11 12 29 31 34 3a 45 46 49 4a 4e 4f 64     .....)14:EFIJNOd
ffffffffc001876b:	65 5c b6 b7 1b 1c 07 08 0a 0b 14 17 36 39 3a a8     e\..........69:.
ffffffffc001877b:	a9 d8 d9 09 37 90 91 a8 07 0a 3b 3e 66 69 8f 92     ....7.....;>fi..
ffffffffc001878b:	6f 5f bf ee ef 5a 62 f4 fc ff 9a 9b 2e 2f 27 28     o_...Zb....../'(
ffffffffc001879b:	55 9d a0 a1 a3 a4 a7 a8 ad ba bc c4 06 0b 0c 15     U...............
ffffffffc00187ab:	1d 3a 3f 45 51 a6 a7 cc cd a0 07 19 1a 22 25 3e     .:?EQ........"%>
ffffffffc00187bb:	3f e7 ec ef ff c5 c6 04 20 23 25 26 28 33 38 3a     ?....... #%&(38:
ffffffffc00187cb:	48 4a 4c 50 53 55 56 58 5a 5c 5e 60 63 65 66 6b     HJLPSUVXZ\^`cefk
ffffffffc00187db:	73 78 7d 7f 8a a4 aa af b0 c0 d0 ae af 6e 6f 93     sx}..........no.

ffffffffc00187eb <anon.4a821f7c0280114971449ed0cf6e5daa.28.llvm.14834836203371451150>:
ffffffffc00187eb:	5e 22 7b 05 03 04 2d 03 66 03 01 2f 2e 80 82 1d     ^"{...-.f../....
ffffffffc00187fb:	03 31 0f 1c 04 24 09 1e 05 2b 05 44 04 0e 2a 80     .1...$...+.D..*.
ffffffffc001880b:	aa 06 24 04 24 04 28 08 34 0b 4e 43 81 37 09 16     ..$.$.(.4.NC.7..
ffffffffc001881b:	0a 08 18 3b 45 39 03 63 08 09 30 16 05 21 03 1b     ...;E9.c..0..!..
ffffffffc001882b:	05 01 40 38 04 4b 05 2f 04 0a 07 09 07 40 20 27     ..@8.K./.....@ '
ffffffffc001883b:	04 0c 09 36 03 3a 05 1a 07 04 0c 07 50 49 37 33     ...6.:......PI73
ffffffffc001884b:	0d 33 07 2e 08 0a 81 26 52 4e 28 08 2a 16 1a 26     .3.....&RN(.*..&
ffffffffc001885b:	1c 14 17 09 4e 04 24 09 44 0d 19 07 0a 06 48 08     ....N.$.D.....H.
ffffffffc001886b:	27 09 75 0b 3f 41 2a 06 3b 05 0a 06 51 06 01 05     '.u.?A*.;...Q...
ffffffffc001887b:	10 03 05 80 8b 62 1e 48 08 0a 80 a6 5e 22 45 0b     .....b.H....^"E.
ffffffffc001888b:	0a 06 0d 13 3a 06 0a 36 2c 04 17 80 b9 3c 64 53     ....:..6,....<dS
ffffffffc001889b:	0c 48 09 0a 46 45 1b 48 08 53 0d 49 81 07 46 0a     .H..FE.H.S.I..F.
ffffffffc00188ab:	1d 03 47 49 37 03 0e 08 0a 06 39 07 0a 81 36 19     ..GI7.....9...6.
ffffffffc00188bb:	80 b7 01 0f 32 0d 83 9b 66 75 0b 80 c4 8a 4c 63     ....2...fu....Lc
ffffffffc00188cb:	0d 84 2f 8f d1 82 47 a1 b9 82 39 07 2a 04 5c 06     ../...G...9.*.\.
ffffffffc00188db:	26 0a 46 0a 28 05 13 82 b0 5b 65 4b 04 39 07 11     &.F.(....[eK.9..
ffffffffc00188eb:	40 05 0b 02 0e 97 f8 08 84 d6 2a 09 a2 e7 81 33     @.........*....3
ffffffffc00188fb:	2d 03 11 04 08 81 8c 89 04 6b 05 0d 03 09 07 10     -........k......
ffffffffc001890b:	92 60 47 09 74 3c 80 f6 0a 73 08 70 15 46 80 9a     .`G.t<...s.p.F..
ffffffffc001891b:	14 0c 57 09 19 80 87 81 47 03 85 42 0f 15 84 50     ..W.....G..B...P
ffffffffc001892b:	1f 80 e1 2b 80 d5 2d 03 1a 04 02 81 40 1f 11 3a     ...+..-.....@..:
ffffffffc001893b:	05 01 84 e0 80 f7 29 4c 04 0a 04 02 83 11 44 4c     ......)L......DL
ffffffffc001894b:	3d 80 c2 3c 06 01 04 55 05 1b 34 02 81 0e 2c 04     =..<...U..4...,.
ffffffffc001895b:	64 0c 56 0a 80 ae 38 1d 0d 2c 04 09 07 02 0e 06     d.V...8..,......
ffffffffc001896b:	80 9a 83 d8 05 10 03 0d 03 74 0c 59 07 0c 04 01     .........t.Y....
ffffffffc001897b:	0f 0c 04 38 08 0a 06 28 08 22 4e 81 54 0c 15 03     ...8...(."N.T...
ffffffffc001898b:	05 03 07 09 1d 03 0b 05 06 0a 0a 06 08 08 07 09     ................
ffffffffc001899b:	80 cb 25 0a 84 06 2f 68 6f 6d 65 2f 73 66 62 65     ..%.../home/sfbe
ffffffffc00189ab:	61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c 63 68     a/.rustup/toolch
ffffffffc00189bb:	61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78 38 36     ains/nightly-x86
ffffffffc00189cb:	5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69 6e 75     _64-unknown-linu
ffffffffc00189db:	78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74 6c 69     x-gnu/lib/rustli
ffffffffc00189eb:	62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62 72 61     b/src/rust/libra
ffffffffc00189fb:	72 79 2f 63 6f 72 65 2f 73 72 63 2f 66 6d 74 2f     ry/core/src/fmt/
ffffffffc0018a0b:	6e 75 6d 2e 72 73 cc cc cc cc cc cc cc a1 89 01     num.rs..........
ffffffffc0018a1b:	c0 ff ff ff ff 70 00 00 00 00 00 00 00 cd 01 00     .....p..........
ffffffffc0018a2b:	00 05 00 00 00 2e 2e cc cc cc cc cc cc 30 8a 01     .............0..
ffffffffc0018a3b:	c0 ff ff ff ff 02 00 00 00 00 00 00 00              .............

ffffffffc0018a48 <anon.dd2818591b42213fe1fcfb0fc14b1510.45.llvm.17494642119417435983>:
ffffffffc0018a48:	72 61 6e 67 65 20 73 74 61 72 74 20 69 6e 64 65     range start inde
ffffffffc0018a58:	78 20                                               x 

ffffffffc0018a5a <anon.dd2818591b42213fe1fcfb0fc14b1510.46.llvm.17494642119417435983>:
ffffffffc0018a5a:	20 6f 75 74 20 6f 66 20 72 61 6e 67 65 20 66 6f      out of range fo
ffffffffc0018a6a:	72 20 73 6c 69 63 65 20 6f 66 20 6c 65 6e 67 74     r slice of lengt
ffffffffc0018a7a:	68 20 cc cc cc cc                                   h ....

ffffffffc0018a80 <anon.dd2818591b42213fe1fcfb0fc14b1510.47.llvm.17494642119417435983>:
ffffffffc0018a80:	48 8a 01 c0 ff ff ff ff 12 00 00 00 00 00 00 00     H...............
ffffffffc0018a90:	5a 8a 01 c0 ff ff ff ff 22 00 00 00 00 00 00 00     Z.......".......

ffffffffc0018aa0 <anon.dd2818591b42213fe1fcfb0fc14b1510.48.llvm.17494642119417435983>:
ffffffffc0018aa0:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0018ab0:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0018ac0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0018ad0:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0018ae0:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0018af0:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0018b00:	65 2f 73 72 63 2f 73 6c 69 63 65 2f 69 6e 64 65     e/src/slice/inde
ffffffffc0018b10:	78 2e 72 73 cc cc cc cc                             x.rs....

ffffffffc0018b18 <anon.dd2818591b42213fe1fcfb0fc14b1510.49.llvm.17494642119417435983>:
ffffffffc0018b18:	a0 8a 01 c0 ff ff ff ff 74 00 00 00 00 00 00 00     ........t.......
ffffffffc0018b28:	34 00 00 00 05 00 00 00                             4.......

ffffffffc0018b30 <anon.dd2818591b42213fe1fcfb0fc14b1510.54.llvm.17494642119417435983>:
ffffffffc0018b30:	30 64 01 c0 ff ff ff ff 10 00 00 00 00 00 00 00     0d..............
ffffffffc0018b40:	5a 8a 01 c0 ff ff ff ff 22 00 00 00 00 00 00 00     Z.......".......

ffffffffc0018b50 <anon.dd2818591b42213fe1fcfb0fc14b1510.55.llvm.17494642119417435983>:
ffffffffc0018b50:	a0 8a 01 c0 ff ff ff ff 74 00 00 00 00 00 00 00     ........t.......
ffffffffc0018b60:	49 00 00 00 05 00 00 00                             I.......

ffffffffc0018b68 <anon.dd2818591b42213fe1fcfb0fc14b1510.59.llvm.17494642119417435983>:
ffffffffc0018b68:	73 6c 69 63 65 20 69 6e 64 65 78 20 73 74 61 72     slice index star
ffffffffc0018b78:	74 73 20 61 74 20                                   ts at 

ffffffffc0018b7e <anon.dd2818591b42213fe1fcfb0fc14b1510.60.llvm.17494642119417435983>:
ffffffffc0018b7e:	20 62 75 74 20 65 6e 64 73 20 61 74 20 cc cc cc      but ends at ...
ffffffffc0018b8e:	cc cc                                               ..

ffffffffc0018b90 <anon.dd2818591b42213fe1fcfb0fc14b1510.61.llvm.17494642119417435983>:
ffffffffc0018b90:	68 8b 01 c0 ff ff ff ff 16 00 00 00 00 00 00 00     h...............
ffffffffc0018ba0:	7e 8b 01 c0 ff ff ff ff 0d 00 00 00 00 00 00 00     ~...............

ffffffffc0018bb0 <anon.dd2818591b42213fe1fcfb0fc14b1510.62.llvm.17494642119417435983>:
ffffffffc0018bb0:	a0 8a 01 c0 ff ff ff ff 74 00 00 00 00 00 00 00     ........t.......
ffffffffc0018bc0:	5c 00 00 00 05 00 00 00 cc cc cc cc cc cc cc cc     \...............

ffffffffc0018bd0 <str.0>:
ffffffffc0018bd0:	61 74 74 65 6d 70 74 20 74 6f 20 61 64 64 20 77     attempt to add w
ffffffffc0018be0:	69 74 68 20 6f 76 65 72 66 6c 6f 77 cc cc cc cc     ith overflow....

ffffffffc0018bf0 <str.3>:
ffffffffc0018bf0:	61 74 74 65 6d 70 74 20 74 6f 20 73 75 62 74 72     attempt to subtr
ffffffffc0018c00:	61 63 74 20 77 69 74 68 20 6f 76 65 72 66 6c 6f     act with overflo
ffffffffc0018c10:	77 2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75     w/home/sfbea/.ru
ffffffffc0018c20:	73 74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f     stup/toolchains/
ffffffffc0018c30:	6e 69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75     nightly-x86_64-u
ffffffffc0018c40:	6e 6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75     nknown-linux-gnu
ffffffffc0018c50:	2f 6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63     /lib/rustlib/src
ffffffffc0018c60:	2f 72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f     /rust/library/co
ffffffffc0018c70:	72 65 2f 73 72 63 2f 63 68 61 72 2f 63 6f 6e 76     re/src/char/conv
ffffffffc0018c80:	65 72 74 2e 72 73 cc cc 11 8c 01 c0 ff ff ff ff     ert.rs..........
ffffffffc0018c90:	75 00 00 00 00 00 00 00 1a 00 00 00 33 00 00 00     u...........3...
ffffffffc0018ca0:	63 61 6c 6c 65 64 20 60 4f 70 74 69 6f 6e 3a 3a     called `Option::
ffffffffc0018cb0:	75 6e 77 72 61 70 28 29 60 20 6f 6e 20 61 20 60     unwrap()` on a `
ffffffffc0018cc0:	4e 6f 6e 65 60 20 76 61 6c 75 65 cc cc cc cc cc     None` value.....
ffffffffc0018cd0:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0018ce0:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0018cf0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0018d00:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0018d10:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0018d20:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0018d30:	65 2f 73 72 63 2f 73 6c 69 63 65 2f 6d 6f 64 2e     e/src/slice/mod.
ffffffffc0018d40:	72 73 cc cc cc cc cc cc d0 8c 01 c0 ff ff ff ff     rs..............
ffffffffc0018d50:	72 00 00 00 00 00 00 00 6c 09 00 00 17 00 00 00     r.......l.......
ffffffffc0018d60:	d0 8c 01 c0 ff ff ff ff 72 00 00 00 00 00 00 00     ........r.......
ffffffffc0018d70:	80 09 00 00 14 00 00 00 2f 68 6f 6d 65 2f 73 66     ......../home/sf
ffffffffc0018d80:	62 65 61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c     bea/.rustup/tool
ffffffffc0018d90:	63 68 61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78     chains/nightly-x
ffffffffc0018da0:	38 36 5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69     86_64-unknown-li
ffffffffc0018db0:	6e 75 78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74     nux-gnu/lib/rust
ffffffffc0018dc0:	6c 69 62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62     lib/src/rust/lib
ffffffffc0018dd0:	72 61 72 79 2f 63 6f 72 65 2f 73 72 63 2f 73 74     rary/core/src/st
ffffffffc0018de0:	72 2f 74 72 61 69 74 73 2e 72 73 cc cc cc cc cc     r/traits.rs.....
ffffffffc0018df0:	78 8d 01 c0 ff ff ff ff 73 00 00 00 00 00 00 00     x.......s.......
ffffffffc0018e00:	62 01 00 00 13 00 00 00 2f 68 6f 6d 65 2f 73 66     b......./home/sf
ffffffffc0018e10:	62 65 61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c     bea/.rustup/tool
ffffffffc0018e20:	63 68 61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78     chains/nightly-x
ffffffffc0018e30:	38 36 5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69     86_64-unknown-li
ffffffffc0018e40:	6e 75 78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74     nux-gnu/lib/rust
ffffffffc0018e50:	6c 69 62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62     lib/src/rust/lib
ffffffffc0018e60:	72 61 72 79 2f 63 6f 72 65 2f 73 72 63 2f 73 74     rary/core/src/st
ffffffffc0018e70:	72 2f 76 61 6c 69 64 61 74 69 6f 6e 73 2e 72 73     r/validations.rs
ffffffffc0018e80:	08 8e 01 c0 ff ff ff ff 78 00 00 00 00 00 00 00     ........x.......
ffffffffc0018e90:	31 00 00 00 24 00 00 00 08 8e 01 c0 ff ff ff ff     1...$...........
ffffffffc0018ea0:	78 00 00 00 00 00 00 00 38 00 00 00 28 00 00 00     x.......8...(...
ffffffffc0018eb0:	08 8e 01 c0 ff ff ff ff 78 00 00 00 00 00 00 00     ........x.......
ffffffffc0018ec0:	40 00 00 00 2c 00 00 00 20 28 62 79 74 65 73 20     @...,... (bytes 
ffffffffc0018ed0:	2f 68 6f 6d 65 2f 73 66 62 65 61 2f 2e 72 75 73     /home/sfbea/.rus
ffffffffc0018ee0:	74 75 70 2f 74 6f 6f 6c 63 68 61 69 6e 73 2f 6e     tup/toolchains/n
ffffffffc0018ef0:	69 67 68 74 6c 79 2d 78 38 36 5f 36 34 2d 75 6e     ightly-x86_64-un
ffffffffc0018f00:	6b 6e 6f 77 6e 2d 6c 69 6e 75 78 2d 67 6e 75 2f     known-linux-gnu/
ffffffffc0018f10:	6c 69 62 2f 72 75 73 74 6c 69 62 2f 73 72 63 2f     lib/rustlib/src/
ffffffffc0018f20:	72 75 73 74 2f 6c 69 62 72 61 72 79 2f 63 6f 72     rust/library/cor
ffffffffc0018f30:	65 2f 73 72 63 2f 73 74 72 2f 6d 6f 64 2e 72 73     e/src/str/mod.rs
ffffffffc0018f40:	5b 2e 2e 2e 5d 62 79 74 65 20 69 6e 64 65 78 20     [...]byte index 
ffffffffc0018f50:	20 69 73 20 6f 75 74 20 6f 66 20 62 6f 75 6e 64      is out of bound
ffffffffc0018f60:	73 20 6f 66 20 60 60 cc 45 8f 01 c0 ff ff ff ff     s of ``.E.......
ffffffffc0018f70:	0b 00 00 00 00 00 00 00 50 8f 01 c0 ff ff ff ff     ........P.......
ffffffffc0018f80:	16 00 00 00 00 00 00 00 66 8f 01 c0 ff ff ff ff     ........f.......
ffffffffc0018f90:	01 00 00 00 00 00 00 00 d0 8e 01 c0 ff ff ff ff     ................
ffffffffc0018fa0:	70 00 00 00 00 00 00 00 6b 00 00 00 09 00 00 00     p.......k.......
ffffffffc0018fb0:	62 65 67 69 6e 20 3c 3d 20 65 6e 64 20 28 cc cc     begin <= end (..
ffffffffc0018fc0:	b0 8f 01 c0 ff ff ff ff 0e 00 00 00 00 00 00 00     ................
ffffffffc0018fd0:	a8 66 01 c0 ff ff ff ff 04 00 00 00 00 00 00 00     .f..............
ffffffffc0018fe0:	20 64 01 c0 ff ff ff ff 10 00 00 00 00 00 00 00      d..............
ffffffffc0018ff0:	66 8f 01 c0 ff ff ff ff 01 00 00 00 00 00 00 00     f...............
ffffffffc0019000:	d0 8e 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     ........p.......
ffffffffc0019010:	6f 00 00 00 05 00 00 00 d0 8e 01 c0 ff ff ff ff     o...............
ffffffffc0019020:	70 00 00 00 00 00 00 00 7d 00 00 00 2d 00 00 00     p.......}...-...
ffffffffc0019030:	d0 8e 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     ........p.......
ffffffffc0019040:	7e 00 00 00 22 00 00 00 20 69 73 20 6e 6f 74 20     ~..."... is not 
ffffffffc0019050:	61 20 63 68 61 72 20 62 6f 75 6e 64 61 72 79 3b     a char boundary;
ffffffffc0019060:	20 69 74 20 69 73 20 69 6e 73 69 64 65 20 29 20      it is inside ) 
ffffffffc0019070:	6f 66 20 60 cc cc cc cc 45 8f 01 c0 ff ff ff ff     of `....E.......
ffffffffc0019080:	0b 00 00 00 00 00 00 00 48 90 01 c0 ff ff ff ff     ........H.......
ffffffffc0019090:	26 00 00 00 00 00 00 00 c8 8e 01 c0 ff ff ff ff     &...............
ffffffffc00190a0:	08 00 00 00 00 00 00 00 6e 90 01 c0 ff ff ff ff     ........n.......
ffffffffc00190b0:	06 00 00 00 00 00 00 00 66 8f 01 c0 ff ff ff ff     ........f.......
ffffffffc00190c0:	01 00 00 00 00 00 00 00 d0 8e 01 c0 ff ff ff ff     ................
ffffffffc00190d0:	70 00 00 00 00 00 00 00 7f 00 00 00 05 00 00 00     p...............
ffffffffc00190e0:	d0 8e 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     ........p.......
ffffffffc00190f0:	05 01 00 00 1d 00 00 00 d0 8e 01 c0 ff ff ff ff     ................
ffffffffc0019100:	70 00 00 00 00 00 00 00 0a 01 00 00 2e 00 00 00     p...............
ffffffffc0019110:	d0 8e 01 c0 ff ff ff ff 70 00 00 00 00 00 00 00     ........p.......
ffffffffc0019120:	0a 01 00 00 16 00 00 00 2f 68 6f 6d 65 2f 73 66     ......../home/sf
ffffffffc0019130:	62 65 61 2f 2e 72 75 73 74 75 70 2f 74 6f 6f 6c     bea/.rustup/tool
ffffffffc0019140:	63 68 61 69 6e 73 2f 6e 69 67 68 74 6c 79 2d 78     chains/nightly-x
ffffffffc0019150:	38 36 5f 36 34 2d 75 6e 6b 6e 6f 77 6e 2d 6c 69     86_64-unknown-li
ffffffffc0019160:	6e 75 78 2d 67 6e 75 2f 6c 69 62 2f 72 75 73 74     nux-gnu/lib/rust
ffffffffc0019170:	6c 69 62 2f 73 72 63 2f 72 75 73 74 2f 6c 69 62     lib/src/rust/lib
ffffffffc0019180:	72 61 72 79 2f 63 6f 72 65 2f 73 72 63 2f 75 6e     rary/core/src/un
ffffffffc0019190:	69 63 6f 64 65 2f 75 6e 69 63 6f 64 65 5f 64 61     icode/unicode_da
ffffffffc00191a0:	74 61 2e 72 73 cc cc cc 28 91 01 c0 ff ff ff ff     ta.rs...(.......
ffffffffc00191b0:	7d 00 00 00 00 00 00 00 4b 00 00 00 28 00 00 00     }.......K...(...
ffffffffc00191c0:	28 91 01 c0 ff ff ff ff 7d 00 00 00 00 00 00 00     (.......}.......
ffffffffc00191d0:	4f 00 00 00 09 00 00 00 28 91 01 c0 ff ff ff ff     O.......(.......
ffffffffc00191e0:	7d 00 00 00 00 00 00 00 4d 00 00 00 09 00 00 00     }.......M.......
ffffffffc00191f0:	28 91 01 c0 ff ff ff ff 7d 00 00 00 00 00 00 00     (.......}.......
ffffffffc0019200:	54 00 00 00 11 00 00 00 28 91 01 c0 ff ff ff ff     T.......(.......
ffffffffc0019210:	7d 00 00 00 00 00 00 00 56 00 00 00 11 00 00 00     }.......V.......
ffffffffc0019220:	28 91 01 c0 ff ff ff ff 7d 00 00 00 00 00 00 00     (.......}.......
ffffffffc0019230:	57 00 00 00 16 00 00 00 28 91 01 c0 ff ff ff ff     W.......(.......
ffffffffc0019240:	7d 00 00 00 00 00 00 00 58 00 00 00 09 00 00 00     }.......X.......
ffffffffc0019250:	28 91 01 c0 ff ff ff ff 7d 00 00 00 00 00 00 00     (.......}.......
ffffffffc0019260:	52 00 00 00 3e 00 00 00                             R...>...

ffffffffc0019268 <_ZN4core7unicode12unicode_data15grapheme_extend17SHORT_OFFSET_RUNS17hff80492940489e58E>:
ffffffffc0019268:	00 03 00 00 83 04 20 00 91 05 60 00 5d 13 a0 00     ...... ...`.]...
ffffffffc0019278:	12 17 20 1f 0c 20 60 1f ef 2c a0 2b 2a 30 20 2c     .. .. `..,.+*0 ,
ffffffffc0019288:	6f a6 e0 2c 02 a8 60 2d 1e fb 60 2e 00 fe 20 36     o..,..`-..`... 6
ffffffffc0019298:	9e ff 60 36 fd 01 e1 36 01 0a 21 37 24 0d e1 37     ..`6...6..!7$..7
ffffffffc00192a8:	ab 0e 61 39 2f 18 a1 39 30 1c e1 47 f3 1e 21 4c     ..a9/..90..G..!L
ffffffffc00192b8:	f0 6a e1 4f 4f 6f 21 50 9d bc a1 50 00 cf 61 51     .j.OOo!P...P..aQ
ffffffffc00192c8:	65 d1 a1 51 00 da 21 52 00 e0 e1 53 30 e1 61 55     e..Q..!R...S0.aU
ffffffffc00192d8:	ae e2 a1 56 d0 e8 e1 56 20 00 6e 57 f0 01 ff 57     ...V...V .nW...W

ffffffffc00192e8 <_ZN4core7unicode12unicode_data15grapheme_extend7OFFSETS17hf36df6bdf2c19a88E>:
ffffffffc00192e8:	00 70 00 07 00 2d 01 01 01 02 01 02 01 01 48 0b     .p...-........H.
ffffffffc00192f8:	30 15 10 01 65 07 02 06 02 02 01 04 23 01 1e 1b     0...e.......#...
ffffffffc0019308:	5b 0b 3a 09 09 01 18 04 01 09 01 03 01 05 2b 03     [.:...........+.
ffffffffc0019318:	3c 08 2a 18 01 20 37 01 01 01 04 08 04 01 03 07     <.*.. 7.........
ffffffffc0019328:	0a 02 1d 01 3a 01 01 01 02 04 08 01 09 01 0a 02     ....:...........
ffffffffc0019338:	1a 01 02 02 39 01 04 02 04 02 02 03 03 01 1e 02     ....9...........
ffffffffc0019348:	03 01 0b 02 39 01 04 05 01 02 04 01 14 02 16 06     ....9...........
ffffffffc0019358:	01 01 3a 01 01 02 01 04 08 01 07 03 0a 02 1e 01     ..:.............
ffffffffc0019368:	3b 01 01 01 0c 01 09 01 28 01 03 01 37 01 01 03     ;.......(...7...
ffffffffc0019378:	05 03 01 04 07 02 0b 02 1d 01 3a 01 02 01 02 01     ..........:.....
ffffffffc0019388:	03 01 05 02 07 02 0b 02 1c 02 39 02 01 01 02 04     ..........9.....
ffffffffc0019398:	08 01 09 01 0a 02 1d 01 48 01 04 01 02 03 01 01     ........H.......
ffffffffc00193a8:	08 01 51 01 02 07 0c 08 62 01 02 09 0b 06 4a 02     ..Q.....b.....J.
ffffffffc00193b8:	1b 01 01 01 01 01 37 0e 01 05 01 02 05 0b 01 24     ......7........$
ffffffffc00193c8:	09 01 66 04 01 06 01 02 02 02 19 02 04 03 10 04     ..f.............
ffffffffc00193d8:	0d 01 02 02 06 01 0f 01 00 03 00 03 1d 02 1e 02     ................
ffffffffc00193e8:	1e 02 40 02 01 07 08 01 02 0b 09 01 2d 03 01 01     ..@.........-...
ffffffffc00193f8:	75 02 22 01 76 03 04 02 09 01 06 03 db 02 02 01     u.".v...........
ffffffffc0019408:	3a 01 01 07 01 01 01 01 02 08 06 0a 02 01 30 1f     :.............0.
ffffffffc0019418:	31 04 30 07 01 01 05 01 28 09 0c 02 20 04 02 02     1.0.....(... ...
ffffffffc0019428:	01 03 38 01 01 02 03 01 01 03 3a 08 02 02 98 03     ..8.......:.....
ffffffffc0019438:	01 0d 01 07 04 01 06 01 03 02 c6 40 00 01 c3 21     ...........@...!
ffffffffc0019448:	00 03 8d 01 60 20 00 06 69 02 00 04 01 0a 20 02     ....` ..i..... .
ffffffffc0019458:	50 02 00 01 03 01 04 01 19 02 05 01 97 02 1a 12     P...............
ffffffffc0019468:	0d 01 26 08 19 0b 2e 03 30 01 02 04 02 02 27 01     ..&.....0.....'.
ffffffffc0019478:	43 06 02 02 02 02 0c 01 08 01 2f 01 33 01 01 03     C........./.3...
ffffffffc0019488:	02 02 05 02 01 01 2a 02 08 01 ee 01 02 01 04 01     ......*.........
ffffffffc0019498:	00 01 00 10 10 10 00 02 00 01 e2 01 95 05 00 03     ................
ffffffffc00194a8:	01 02 05 04 28 03 04 01 a5 02 00 04 00 02 99 0b     ....(...........
ffffffffc00194b8:	31 04 7b 01 36 0f 29 01 02 02 0a 03 31 04 02 02     1.{.6.).....1...
ffffffffc00194c8:	07 01 3d 03 24 05 01 08 3e 01 0c 02 34 09 0a 04     ..=.$...>...4...
ffffffffc00194d8:	02 01 5f 03 02 01 01 02 06 01 a0 01 03 08 15 02     .._.............
ffffffffc00194e8:	39 02 01 01 01 01 16 01 0e 07 03 05 c3 08 02 03     9...............
ffffffffc00194f8:	01 01 17 01 51 01 02 06 01 01 02 01 01 02 01 02     ....Q...........
ffffffffc0019508:	eb 01 02 04 06 02 01 02 1b 02 55 08 02 01 01 02     ..........U.....
ffffffffc0019518:	6a 01 01 01 02 06 01 01 65 03 02 04 01 05 00 09     j.......e.......
ffffffffc0019528:	01 02 f5 01 0a 02 01 01 04 01 90 04 02 02 04 01     ................
ffffffffc0019538:	20 0a 28 06 02 04 08 01 09 06 02 03 2e 0d 01 02      .(.............
ffffffffc0019548:	00 07 01 06 01 01 52 16 02 07 01 02 01 02 7a 06     ......R.......z.
ffffffffc0019558:	03 01 01 02 01 07 01 01 48 02 03 01 01 01 00 02     ........H.......
ffffffffc0019568:	00 05 3b 07 00 01 3f 04 51 01 00 02 00 2e 02 17     ..;...?.Q.......
ffffffffc0019578:	00 01 01 03 04 05 08 08 02 07 1e 04 94 03 00 37     ...............7
ffffffffc0019588:	04 32 08 01 0e 01 16 05 01 0f 00 07 01 11 02 07     .2..............
ffffffffc0019598:	01 02 01 05 00 07 00 01 3d 04 00 07 6d 07 00 60     ........=...m..`
ffffffffc00195a8:	80 f0 00 cc cc cc cc cc                             ........

ffffffffc00195b0 <_ZN6kernel6_start20IS_MAPPER_INITD_PML417ha7145abaf1b86d3dE.0>:
ffffffffc00195b0:	ff ff ff ff ff ff ff ff                             ........

ffffffffc00195b8 <_ZN9libkernel3out4uart9UART_COM117h6d35e8d6b47cc2a5E>:
ffffffffc00195b8:	80 1b 01 c0 ff ff ff ff 00 00 00 00 00 00 00 00     ................
	...

ffffffffc00195f8 <_ZN9libkernel4memm6MAPPER17h6ee200648c53b980E>:
	...
ffffffffc0019630:	08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00     ................
ffffffffc0019640:	01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00     ................
	...
