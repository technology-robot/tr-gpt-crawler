import argparse
import gcsfs


if __name__ == "__main__":
    # Create the parser
    parser = argparse.ArgumentParser(description="Upload files to Google Cloud Storage")

    # Add arguments
    parser.add_argument("--input_folder", type=str, required=True, help="Local input folder to upload")
    parser.add_argument("--output_folder", type=str, required=True, help="GCS output folder where files will be uploaded")

    # Parse the arguments
    args = parser.parse_args()

    # Use the arguments
    input_folder = args.input_folder
    output_folder = args.output_folder

    # Initialize GCS File System
    gcs_fs = gcsfs.GCSFileSystem()

    # Upload files
    gcs_fs.put(input_folder, output_folder, recursive=True)
