
<?php
$firstName = $_POST["firstName"];
$lastName = $_POST["lastName"];
$userId = $_POST["userId"];

$ocrfile_file_dir = "OCRfile/";

$basicname = basename($_FILES["file"]["name"]);
$ocrfile_dir = $ocrfile_file_dir . "/" . basename($_FILES["file"]["name"]);



if (move_uploaded_file($_FILES["file"]["tmp_name"], $ocrfile_dir))
{

`tesseract $ocrfile_dir $ocrfile_dir -l eng`;
`cat $ocrfile_file_dir/fasta $ocrfile_dir.txt >  $ocrfile_dir.out`;

$ocrfile_dir_result = $ocrfile_file_dir."/".$basicname.".result";

$filesize = abs(filesize($ocrfile_dir_result));

if($filesize == 0)
{
`perl blast/web_blast.pl $ocrfile_dir.out > $ocrfile_dir_result`;
`perl blast/standardout.pl $ocrfile_dir_result > $ocrfile_dir.stand`;

}

$textcontent = file_get_contents("$ocrfile_dir.out");
$filedocumetn = file_get_contents("$ocrfile_dir.stand");


// $filedocumetn = file_get_contents($testfile);

echo json_encode([
"Message" => "The file ".$basicname." has been uploaded.",
"Status" => "OK",
"userId" => $_REQUEST["userId"],
"content" => $filedocumetn
]);

}
else {
echo json_encode([
"Message" => "Sorry, there was an error uploading your file."."<br>",
"Status" => "Errror<br>",
"userId" => $_REQUEST["userId"]
]);
}
?>
