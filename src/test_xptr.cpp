// #include "sparta_types.h"
// using namespace Rcpp;


// // [[Rcpp::export]]
// Rcpp::XPtr<arma::Mat<unsigned short>> create_xptr2(int i, int j) {
//   arma::Mat<unsigned short>* ptr(new arma::Mat<unsigned short>(i, j));
//   (*ptr).fill(1);
//   Rcpp::XPtr<arma::Mat<unsigned short>> p(ptr, true);
//   return p;
// }


// // [[Rcpp::export]]
// Rcpp::XPtr<arma::Mat<unsigned short>> create_xptr(int i, int j) {
//   arma::Mat<unsigned short>* ptr(new arma::Mat<unsigned short>(i, j));
//   Rcpp::XPtr<arma::Mat<unsigned short>> p(ptr, false);
//   return p;
// }

// // [[Rcpp::export]]
// void fill_xptr(Rcpp::XPtr<arma::Mat<unsigned short>>& xptr, int k) {
//   (*xptr).fill(k);
// }

// // [[Rcpp::export]]
// arma::Mat<unsigned short> return_val(Rcpp::XPtr<arma::Mat<unsigned short>>& xptr) {
//   return *xptr;
// }

// // [[Rcpp::export]]
// void release_me(XPtr<arma::Mat<unsigned short>>& xptr) {
//   xptr.release();
// }

// // [[Rcpp::export]]
// SEXP make_xptr() {
//   arma::Mat<unsigned short> A(1000, 1000000);

//   // 1) 
//   // arma::Mat<unsigned short>* ptr = new arma::Mat<unsigned short>;
//   // (*ptr) = A;

//   // 2)
//   arma::Mat<unsigned short>* ptr(new arma::Mat<unsigned short>(A));

//   // 3)
//   // arma::Mat<unsigned short>* ptr;
//   // (*ptr) = A;

//   XPtr<arma::Mat<unsigned short>> p(ptr, false);
//   return p;
// }

// void Finalize(SEXP xptr){
//   delete static_cast<std::vector<int>*>(R_ExternalPtrAddr(xptr));
// }

// // [[Rcpp::export]]
// SEXP make_ptr() {
//   std::vector<int>* ptr;
//   SEXP xptr = PROTECT(R_MakeExternalPtr(ptr, R_NilValue, R_NilValue));
//   R_RegisterCFinalizerEx(xptr, Finalize, TRUE);
//   return xptr;
// }


// // [[Rcpp::export]]
// void finalize(SEXP xp){
//   delete static_cast< std::vector<double> *>(R_ExternalPtrAddr(xp));
// }

// // [[Rcpp::export]]
// SEXP ext_ref_ex() {
//   std::vector<double> * x  = new std::vector<double>(100000000);
//   SEXP xp = PROTECT(R_MakeExternalPtr(x, R_NilValue, R_NilValue));
//   R_RegisterCFinalizer(xp, finalize);
//   UNPROTECT(1);
//   return xp;
// }
