package {{% REPLACE_LANG %}};

import java.io.File;
import java.io.ByteArrayInputStream;
import java.nio.file.Files;
import org.antlr.v4.runtime.*;

class CountingErrorListener extends BaseErrorListener {
  public int count = 0;
  public void syntaxError(Recognizer<?,?> recognizer, Object offendingSymbol,
                          int line, int charPositionInLine,
                          String msg, RecognitionException e) {
    count++;
  }
}

public class main {
  public static void main(String[] args) {
    if (args.length == 0) {
      System.out.printf("usage: java -cp antlr-4.7.1-complete.jar:{{% REPLACE_LANG %}}.jar {{% REPLACE_LANG %}} /path/to/file\n");
      System.out.println("FAIL");
      System.exit(1);
      return;
    }

    System.out.printf("%s\n", args[0]);
    ANTLRFileStream stream;
    try {
      stream = new ANTLRFileStream(args[0]);
    } catch (Exception e) {
      System.out.println("FAIL");
      System.out.println(e.getMessage());
      System.exit(1);
      return;
    }

    var lexer = new {{% REPLACE_LANG %}}Lexer(stream);
    CountingErrorListener lexerErrors = new CountingErrorListener();
    lexer.addErrorListener(lexerErrors);

    var tok = new CommonTokenStream(lexer);

    var parser = new {{% REPLACE_LANG %}}Parser(tok);

    try {
      parser.crate();
    } catch (Exception e) {
      System.out.println("FAIL");
      System.out.println(e.getMessage());
    }

    if (lexerErrors.count + parser.getNumberOfSyntaxErrors() > 0) {
      System.out.println("FAIL");
      System.exit(127);
    } else {
      System.out.println("PASS");
    }
  }
}
