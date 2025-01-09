/// All functions attached on [String].
extension StringExt on String {
  /// Ensure current string is wrapped in html code that clears the background
  ///
  /// A simple quick check to avoid nested attached code: check has '<style>'
  /// tag or not.
  String ensureClearBackground() {
    if (contains('<style>')) {
      return this;
    }

    return '''
<pre>
$this
</pre>

<style>
#postlist div:nth-of-type(-n+2) .tsdm_post_t {background: none !important;}
#postlist>div:nth-of-type(-n+2) .pstatus,#postlist>div:nth-of-type(-n+2) .pstatus+br,#postlist>div:nth-of-type(-n+2) .pstatus+br+br {display: none !important;}
pre {margin-top: 0; font-family: initial; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;}
</style>
'''
        .trim();
  }
}
