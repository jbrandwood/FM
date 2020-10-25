import sys
import os
import mmap



def Help():
	print("transpart.py - FM TOWNS HD Image Partition Transplanter.")
	print("by CaptainYS")
	print("Usage:")
	print("  transpart.py SOURCE.BIN SRC_PARTITION_NAME DESTINATION.BIN DST_PARTITION_NAME")
	print("")
	print("  CAUTION! This progam will write to the hard-disk image without confirmation")
	print("           prompt.  Make sure you don't overwrite the partition you need!")
	print("")
	print("  This program transplants a partition in the source hard-disk image to the")
	print("  destination hard-disk image.")
	print("")
	print("  If the destination hard-disk image already has the partition name same as the")
	print("  DST_PARTITION_NAME, it will overwrites an existing partition with the same name.")
	print("")
	print("  Otherwise, it will appends the source partition to the destination hard-disk")
	print("  image.")
	print("")
	print("  I don't know if it can be used for hard-disk image for other computers.")



def ErrorExit(msg):
	print("ERROR!")
	print(msg)
	quit()



def DropLastSpace(s):
	while 0<len(s) and s[-1]==' ':
		s=s[:-1]
	return s



def ReadPartitionTableSector(fName):
	ifp=open(fName,"rb")
	ifp.seek(512,0);
	sector=ifp.read(512)
	ifp.close()
	return sector



def GetPartitionList(partSect):
	lst=[]
	for i in range(0,10):
		fileOffset=0x20+i*0x30
		bootPart=False
		startSector=0
		sectorCount=0
		partitionName=""
		partitionType=""
		if 0xFF==partSect[fileOffset]:
			bootPart=True
		startSector=partSect[fileOffset+2]+partSect[fileOffset+3]*0x100+partSect[fileOffset+4]*0x10000+partSect[fileOffset+5]*0x1000000
		sectorCount=partSect[fileOffset+6]+partSect[fileOffset+7]*0x100+partSect[fileOffset+8]*0x10000+partSect[fileOffset+9]*0x1000000
		for j in range(0,16):
			if partSect[fileOffset+16+j]==0:
				break
			partitionType=partitionType+chr(partSect[fileOffset+16+j])
		for j in range(0,16):
			if partSect[fileOffset+32+j]==0:
				break
			partitionName=partitionName+chr(partSect[fileOffset+32+j])
		partitionType=DropLastSpace(partitionType)
		partitionName=DropLastSpace(partitionName)
		lst.append([bootPart,startSector,sectorCount,partitionType,partitionName])
	return lst

def StartSector(partition):
	return partition[1]

def SectorCount(partition):
	return partition[2]

def PartitionType(partition):
	return partition[3]

def PartitionName(partition):
	return partition[4]



def FindPartition(partName,partList):
	for part in partList:
		if PartitionName(part)==partName:
			return part
	return None



def MakeDestinationPartition(dstFile,dstPartList,dstPartitionName,srcPartition):
	dstSize=os.path.getsize(dstFile)



def main(argv):
	if(len(argv)!=5):
		Help()
		quit()

	print("From="+argv[1])
	print("To  ="+argv[3])

	srcSize=os.path.getsize(argv[1])
	dstSize=os.path.getsize(argv[3])
	if 0!=srcSize%512:
		ErrorExit("Source hard disk image size is not 512 times integer.")
	if 0!=dstSize%512:
		ErrorExit("Destination hard disk image size is not 512 times integer.")

	srcPartitionTableSector=ReadPartitionTableSector(argv[1])
	dstPartitionTableSector=ReadPartitionTableSector(argv[3])

	srcPartList=GetPartitionList(srcPartitionTableSector)
	dstPartList=GetPartitionList(dstPartitionTableSector)

	print("<<<Source Hard Disk Image Partitions>>>")
	for part in srcPartList:
		print(part)
	print("<<<Destination Hard Disk Image Partitions>>>")
	for part in dstPartList:
		print(part)

	srcPart=FindPartition(argv[2],srcPartList)
	if None==srcPart:
		ErrorExit("Source Partition not found.")


	
	print("!!!!Warning!!!!")
	print("Failure of the operation may corrupt your hard-disk image.")
	while True:
		print("Did you take a backup copy of the hard-disk images?")
		sys.stdout.write("  Enter Y or N>")
		sys.stdout.flush()
		yesNo=sys.stdin.readline()
		yesNo=yesNo.replace('\n','')
		if "Y"==yesNo:
			break
		elif "N"==yesNo:
			print("Take a backup copy and try again.")
			quit()
		else:
			print("Please enter Y or N exactly (One letter, capital).")


	dstPart=FindPartition(argv[4],dstPartList)
	if None==dstPart:
		MakeDestinationPartition(argv[3],dstPartList,argv[4],srcPart)
		dstSize=os.path.getsize(argv[3])
		dstPartitionTableSector=ReadPartitionTableSector(argv[3])
		dstPartList=GetPartitionList(dstPartitionTableSector)
		dstPart=FindPartition(argv[4],dstPartList)
		if None==dstPart:
			ErrorExit("Destination Partition was supposed to be created, but something went wrong.")
	elif PartitionSize(dstPart)<PartitionSize(srcPart):
		ErrorExit("Destination Partition is smaller than Source Partition")

	quit()



	srcFp=open(argv[1],"r+b")
	dstFp=open(argv[3],"r+b")

	srcMM=mmap.mmap(srcFp.fileno(),0)
	dstMM=mmap.mmap(dstFp.fileno(),0)

	srcFp.close()
	dstFp.close()

	return;



if __name__=="__main__":
	main(sys.argv)