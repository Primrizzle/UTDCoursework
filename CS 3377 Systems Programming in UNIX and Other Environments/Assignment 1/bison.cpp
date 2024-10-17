// This C++ code reads multiple input files, searches for a specific pattern in the contents of each file, and writes the results, including the time taken to perform the search, 
// to corresponding output files

#include <chrono>
#include <limits>
#include <locale>
#include <fstream>

#include "LineInfo.h" 

using namespace std;
using namespace chrono; 

const string INPUT_FILE_NAME = "bisonsearchin.txt"; 
const string OUTPUT_FILE_NAME = "bisonfoundin.txt"; 
const uint8_t MAX_FILE_NO = 10; 

int main() {
    // condition cout set to local digit separation commas (USA) 
    cout.imbue(locale(""));

    string searchBisonInGrassStr;
    string inputFileNameStr, outputFileNameStr;
    uint16_t fileCount = 0;

    try {
        do {
            fileCount++;
            inputFileNameStr = outputFileNameStr = to_string(fileCount);

            if (inputFileNameStr.size() == 1) {
                inputFileNameStr = "0" + inputFileNameStr;
                outputFileNameStr = "0" + outputFileNameStr; 
            }
            inputFileNameStr = inputFileNameStr + INPUT_FILE_NAME;
            outputFileNameStr = outputFileNameStr + OUTPUT_FILE_NAME;
        
            ifstream  inputParensStreamObj(inputFileNameStr);
            if (inputParensStreamObj.fail()) 
                throw domain_error(LineInfo("open FAILURE File " + inputFileNameStr, __FILE__,__LINE__));

            ofstream outputParensStreamObj(outputFileNameStr);

            inputParensStreamObj >> searchBisonInGrassStr;

            unsigned answerFoundBisonPatternCount = 0, backParentCount = 0; 

            auto timeStart = steady_clock::now();

            size_t size = searchBisonInGrassStr.size();
            for(unsigned i = 1; i < size; i++)

                if (searchBisonInGrassStr[i - 1] == ')' && searchBisonInGrassStr[i] == ')')
                answerFoundBisonPatternCount += backParentCount;

                else if (searchBisonInGrassStr[i - 1] == '(' && searchBisonInGrassStr[i] == '(')
                backParentCount++;

            auto timeElapsed = duration_cast<nanoseconds> (steady_clock::now() - timeStart);

            outputParensStreamObj << "Time Elapsed (nano) : " << setw(15) << timeElapsed.count() << endl;
            outputParensStreamObj << "Found Pattern Count : " << answerFoundBisonPatternCount << endl;
            outputParensStreamObj << "Searched Pattern    : " << endl;
            outputParensStreamObj << searchBisonInGrassStr << endl;

            outputParensStreamObj.close();

    } while (fileCount != MAX_FILE_NO);
} //try 
    catch(exception& e) {
        cout << e.what() << endl; 
        cout << endl << "Press the enter key once or twice to leave..." << endl; 
        cin.ignore(); 
        cin.get();
        exit(EXIT_FAILURE); 
    } //catch
    return EXIT_SUCCESS;

    } //
