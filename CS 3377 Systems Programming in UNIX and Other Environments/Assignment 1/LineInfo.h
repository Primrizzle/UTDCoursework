// Header file defined to provide detailed error messages. The function is designed to format and return detailed error information as a string.

#ifndef LINE_INFO_H
#define LINE_INFO_H

#include <string>
#include <iostream>
#include <string.h>
#include <cstring>
#include <stdexcept>
#include <sstream>

using namespace std;

string LineInfo(string const& errorstr, char const* file, long line) 
{
    stringstream s;
    s << endl << "EXCEPTION: " << endl << "Oh my Goodness... " << endl << errorstr
        << " in " << file << "\",line:" << line << endl;
    return s.str();
}

#endif
