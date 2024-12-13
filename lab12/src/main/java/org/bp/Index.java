package org.bp;

import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.nio.file.Paths;

public class Index {
    private static final String INDEX_DIRECTORY = "lucene_index";

    public static void main(String[] args) throws IOException {
        PolishAnalyzer analyzer = new PolishAnalyzer();
        Directory directory = FSDirectory.open(Paths.get(INDEX_DIRECTORY));
        IndexWriterConfig config = new IndexWriterConfig(analyzer);

        IndexWriter w = new IndexWriter(directory, config);

        w.addDocument(buildDoc("Lucyna w akcji2", "97800623160971"));
        w.addDocument(buildDoc("Akcje rosną i spadają2", "97803855459551"));
        w.addDocument(buildDoc("Bo ponieważ2", "97815011680071"));
        w.addDocument(buildDoc("Naturalnie urodzeni mordercy2", "97803164856161"));
        w.addDocument(buildDoc("Druhna rodzi2", "97805933017601"));
        w.addDocument(buildDoc("Urodzić się na nowo2", "97806797774891"));

        System.out.println("Indeks został utworzony.");
        w.close();
    }

    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }
}
