TODO List
=========

Limitations:
 * It doesn't queue report execution but executes it immediately.
 * It doesn't store report results.
 * It doesn't limit the size of the result set.
 * No thought given to encoding.
 * Invocation is via a get not a post(!)
 * No protection against sql which is not a select but say delete or update.

Large or slow reports will cause problems.
